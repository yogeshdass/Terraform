variable "name" {
    type = string
    description = "Name of role"
}

variable "allowed_service_policy" {
    type = string
    description = "Policy document for allowing service entity"
}

variable "access_policy" {
    type = string
    description = "Access policy document for allowed service entity"
    default = ""
}

variable "policy_arns" {
    type = list(string)
    description = "(optional) describe your variable"
    default = []
}
variable "enable_instance_profile" {
    type = bool
    description = "(optional) describe your variable"
    default = false
}