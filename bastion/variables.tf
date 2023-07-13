variable "vm_connection" {
    description = "connection key"
    default = "qemu+ssh://erasmus@192.168.1.254/system?keyfile=erasmusATekmlDOTint"
}

variable "vm_disk_path" {
    description = "path for libvirt pool"
    default     = "/zeusPool/kvm/ubuntuPoolBastion"
}

variable "vm_os_img_url" {
    description = "os image url"
    default = "http://cloud-images.ubuntu.com/releases/focal/release-20211021/ubuntu-20.04-server-cloudimg-amd64.img"
}

variable "vm_pool_name" {
    description = "name of the pool"
    default     = "ubuntuPoolBastion"
}

variable "vm_network_name" {
    description = "name of vm network"
    default     = "vm_network_bastion"
}

variable "vm_username" {
    description = "the ssh user to use"
    default     = "k8sdeployr"
}

variable "vm_ssh_private_key" {
    description = "the private key to use"
    default     = "~/.ssh/erasmusATekmlDOTint"
}

variable "vm_timezone" {
    description = "time zone"
    default = "America/New_York"
}

variable "vm_cidr_block" {
    description = "cidr block"
    default = "192.168.1.0/24"
}

variable "vm_gateway" {
    description = "vm gateway"
    default = "192.168.1.1"
}

variable "vm_hosts" {
  type        = list(object({name=string, ip=string}))
  default     = [{name="bastion", ip="192.168.1.70"}]
  description = "defined hosts"
}
