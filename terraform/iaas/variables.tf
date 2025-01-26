variable "resource_group_name" {
  default = "t-clo-901-rns-0"
  type        = string
}
 
variable "location" {
  default = "WestEurope"
  type        = string
}
 
variable "devtestlab_name" {
  default = "t-clo-901-rns-0"
  type        = string
}
 
variable "lab_subnet_name" {
  default = "t-clo-901-rns-0Subnet"
  type        = string
}
 
variable "lab_virtual_network_id" {
  type        = string
  sensitive = true
}

variable "instance_count" {
  description = "number of instance to deploy"
  type = number
}
 
variable "username_app" {
  description = "username"
  type        = string
  sensitive = true
}
 
variable "password_app" {
  description = "password"
  type        = string
  sensitive = true
}

variable "ansible_laravel_repo" {
  description = "remote repo with client app"
  type        = string
  sensitive = true
}

variable "docker_traefik_ports" {
  description = ""
  type = string
  sensitive = true
}


variable "docker_db_connection" {
  description = "db env var"
  type = string
  sensitive = true
}