variable "name" {
    type = string
    description = "Name of the glue job"
}

variable "script_path" {
    type = string
    description = "path of the script"
}

variable "glue_version" {
  type = string
  default = "4.0"
}

variable "worker_type" {
    type = string
    default = "G.1X"
}

variable "number_of_workers" {
  type = number
  default = 10
}

variable "max_retries" {
  type = number
  default = 0
}

variable "timeout" {
  type = number
  default = 2880
}

variable "max_concurrent_runs" {
  type = number
  default = 1
}

variable "command_name" {
    type = string
    default = "glueetl"
}