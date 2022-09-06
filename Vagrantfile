# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Load variables from .env
  config.env.enable

  env_box_name = ENV["BOX_NAME"] || "dev"
  env_ram = ENV["RAM_MEMORY"] || 8192
  env_cpus = ENV["CPU_COUNT"] || 4
  env_private_ip = ENV["PRIVATE_IP"] || "192.168.56.4"

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.define env_box_name
  config.vm.hostname = env_box_name
  config.vm.network "private_network", ip: env_private_ip

  config.vm.provider "virtualbox" do |v|
    v.memory = env_ram
    v.cpus = env_cpus
    v.name = env_box_name
    # only use "gui = true" if you run into weird issues - sometimes the VM requires user input?
    # v.gui = true
  end

  config.ssh.forward_agent = true
  # Vagrant docs indicate that username/password is not the recommended ssh method,
  # but every other way seems to have issues, e.g.
  #   1. machine is provisioned correctly, but cannot be re-provisioned in the future
  #   2. machine cannot be provisioned at all
  #   3. machine works fine, but SSH keys are not forwarded (which breaks GitHub auth for example)
  # I'm sure it's a problem with my configuration, but ultimately this is a local VM and
  # there is no security risk to username/password authentication
  config.ssh.username = 'vagrant'
  config.ssh.password = 'vagrant'

  config.vm.provision "shell", path: "provision.sh"
  config.vm.provision "shell", path: "customization.sh"
end
