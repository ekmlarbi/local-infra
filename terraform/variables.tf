variable "vm_connection" {
    description = "connection key"
    default = "qemu+ssh://erasmus@192.168.1.254/system?keyfile=/home/erasmus/.ssh/erasmusATekmlDOTint"
}

variable "vm_disk_path" {
    description = "path for libvirt pool"
    default     = "/zeusPool/kvm/ubuntuPool"
}

variable "vm_os_img_url" {
    description = "os image url"
    default = "http://cloud-images.ubuntu.com/releases/focal/release-20211021/ubuntu-20.04-server-cloudimg-amd64.img"
}

variable "vm_username" {
    description = "the ssh user to use"
    default     = "ubuntu"
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
  default     = [{name="nexus", ip="192.168.1.71"}, {name="vault", ip="192.168.1.72"}, {name="gogs", ip="192.168.1.73"}, {name="concourse", ip="192.168.1.74"}]
  description = "defined hosts"
}
