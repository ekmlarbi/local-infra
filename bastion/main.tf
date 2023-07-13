provider "libvirt" {
    uri = var.vm_connection
}

resource "libvirt_pool" "ubuntu_pool" {
    name = "${var.vm_pool_name}"
    type = "dir"
    path = "${var.vm_disk_path}"
}

resource "libvirt_volume" "ubuntu_base" {
    name = "ubuntu_2004_base"
    pool = libvirt_pool.ubuntu_pool.name
    source = var.vm_os_img_url
    format = "qcow2"
}

resource "libvirt_volume" "ubuntu_node" {
    for_each = {for host in var.vm_hosts: host.name => host}
    name = "ubuntu_node_${each.value.name}"
    pool = libvirt_pool.ubuntu_pool.name
    base_volume_id = libvirt_volume.ubuntu_base.id
    size = 10 * 1024 * 1024 * 1024
}

data "template_file" "user_data" {
    for_each = {for host in var.vm_hosts: host.name => host}
    template = file("${path.module}/cloud_init.yml")
    vars = {
        hostname = "${each.value.name}"
        timezone = var.vm_timezone
        username = var.vm_username
    }
}

data "template_file" "network_config" {
    for_each = {for host in var.vm_hosts: host.name => host}
    template = file("${path.module}/cloud_init_network.yml")
    vars = {
        address = "${each.value.ip}"
        gateway = var.vm_gateway
    }
}

resource "libvirt_cloudinit_disk" "cloudinit_disk" {
    for_each = {for host in var.vm_hosts: host.name => host}
    name           = "cloudinit_disk_${each.value.name}.iso"
    user_data      = data.template_file.user_data["${each.key}"].rendered
    network_config = data.template_file.network_config["${each.key}"].rendered
    pool           = libvirt_pool.ubuntu_pool.name
}

resource "libvirt_network" "vm_network" {
    autostart   = true
    name        = "${var.vm_network_name}"
    mode        = "bridge"
    bridge      = "br0"
    addresses   = [var.vm_cidr_block]
}


resource "libvirt_domain" "domain_ubuntu" {
    for_each = {for host in var.vm_hosts: host.name => host}
    autostart = true
    name   = "${each.value.name}"
    memory = "1024"
    vcpu   = 1

    qemu_agent = true

    cloudinit = libvirt_cloudinit_disk.cloudinit_disk["${each.key}"].id 

    boot_device {
        dev = [ "hd", "network"]
    }

    network_interface {
        macvtap = "eno1"
        network_id = "${libvirt_network.vm_network.id}"
        network_name = "${libvirt_network.vm_network.name}"
        hostname = "${each.value.name}"
        bridge = "${libvirt_network.vm_network.bridge}"
    }

    disk {
        volume_id = libvirt_volume.ubuntu_node["${each.value.name}"].id
    }

    console {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type        = "pty"
        target_type = "virtio"
        target_port = "1"
    }

    graphics {
        type        = "spice"
        listen_type = "address"
        autoport    = true
    }  

    provisioner "local-exec" {
        working_dir = "../ansible"
        command = "ansible-playbook --inventory ${each.value.ip}, --private-key ${var.vm_ssh_private_key} --user k8sdeployr ${each.value.name}.yaml"
    }
}