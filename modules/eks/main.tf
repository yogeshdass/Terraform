resource "aws_eks_cluster" "ControlPlane" {
    depends_on = [aws_cloudwatch_log_group.ControlPlaneLogs]
    name = var.name
    role_arn = var.eks_cluster_role_arn
    vpc_config {
        endpoint_public_access = true
        endpoint_private_access = false
        public_access_cidrs = ["0.0.0.0/0"]
        subnet_ids = var.subnet_ids
    }
    enabled_cluster_log_types = ["api","audit","authenticator","controllerManager","scheduler"]
    #tags = {}
    version = var.kubernetes_version
}

resource "aws_cloudwatch_log_group" "ControlPlaneLogs" {
    name = "/aws/eks/${var.name}/cluster"
    retention_in_days = 7
}

data "aws_ssm_parameter" "EKSImageID" {
    name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.ControlPlane.version}/amazon-linux-2/recommended/image_id"
}
resource "aws_launch_template" "WorkerNodeLaunchTemplate" {
    name = "${var.name}-WorkerNodeLaunchTemplate"
    block_device_mappings {
        device_name = "/dev/xvda"
        ebs {
            volume_size = 30
            delete_on_termination = true
            volume_type = "gp2"
        }
    }
    iam_instance_profile {
        arn = var.node_instance_profile_arn
    }
    image_id = data.aws_ssm_parameter.EKSImageID.value
    instance_type = "t2.medium"
    key_name = "test"
    metadata_options {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
    }
    vpc_security_group_ids = [var.security_group]
    user_data =base64encode(<<-EOF
        #!/bin/bash
        set -o xtrace
        /etc/eks/bootstrap.sh ${var.name} 
    EOF
    )
}
#${BootstrapArguments}


resource "aws_autoscaling_group" "WorkerNodeASG" {
    depends_on = [aws_launch_template.WorkerNodeLaunchTemplate]
    desired_capacity   = 3
    launch_template {
        id      = aws_launch_template.WorkerNodeLaunchTemplate.id
        version = aws_launch_template.WorkerNodeLaunchTemplate.latest_version
    }
    max_size           = 4
    min_size           = 1
    tags = [
        {
            "key" = "kubernetes.io/cluster/${var.name}"
            "value" = "owned"
            "propagate_at_launch" = true
        },
        {
            "key" = "Name"
            "value" = "${var.name}-Worker-Node"
            "propagate_at_launch" = true
        }
    ]
    vpc_zone_identifier = [
        "subnet-00ab58d290389bcdd",
        "subnet-0f092a4d279ab407f",
        "subnet-04b82e9f7e7f3f9da"
    ]
}
