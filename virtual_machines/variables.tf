variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "prefix" {
  type        = string
  default     = "win-vm-iis"
  description = "Prefix of the resource name"
}

variable "sql_license" {
  type        = string
  default     = "PAYG"
}

variable "sql_password" {
  type        = string
  default     = "Password1234!"
}

variable "sql_username" {
  type        = string
  default     = "sqllogin"
}
variable "sql_port" {
  type        = string
  default     =  "1433"
}

variable "account_tier" {
  type = string
  default = "Standard"
}

variable "account_replication_type" {
  type = string
  default = "LRS"
}

variable "storage_account_name" {
  type = string
  default = "mystorage"
}