#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "att-dp" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "att-dp-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_subnet" "att-dp" {
  count = 3

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.att-dp.id}"

  tags = "${
    map(
     "Name", "att-dp-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "att-dp" {
  vpc_id = "${aws_vpc.att-dp.id}"

  tags {
    Name = "att-dp"
  }
}

resource "aws_route_table" "att-dp" {
  vpc_id = "${aws_vpc.att-dp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.att-dp.id}"
  }
}

resource "aws_route_table_association" "att-dp" {
  count = 3

  subnet_id      = "${aws_subnet.att-dp.*.id[count.index]}"
  route_table_id = "${aws_route_table.att-dp.id}"
}