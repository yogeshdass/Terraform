variable "name" {
    type = string
    description = "(optional) describe your variable"
}

variable "eks_cluster_role_arn" {
    type = string
    description = "(optional) describe your variable"
}

variable "subnet_ids" {
    type = list(string)
    description = "(optional) describe your variable"
}

variable "kubernetes_version" {
    type = string
    description = "(optional) describe your variable"
}

variable "node_instance_profile_arn" {
    type = string
    description = "(optional) describe your variable"
}

variable "security_group" {
    type = string
    description = "(optional) describe your variable"
}