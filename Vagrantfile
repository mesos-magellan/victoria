# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|

  NUM_AGENTS = 2
  AGENT_IP_RANGE_START = 100
  AGENT_MEM = 256

  config.vm.box = "debian/jessie64"
  # XXX Hack to fix https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
  end

  config.vm.provision "shell", inline: "echo Hello"
  config.vm.provision :shell, path: "bootstrap/bootstrap.sh"

  config.vm.define "master" do |master|
    master.vm.network :private_network, ip: "10.144.144.10"
    master.vm.provision :shell, path: "bootstrap/install_mesos.sh"
    master.vm.provision :shell, path: "bootstrap/master.sh"
  end

  if NUM_AGENTS > 254-AGENT_IP_RANGE_START
    raise "Too many agents"
  end
  (1..NUM_AGENTS).each do |i|
    agent_num = "#{i}".rjust(3, '0')
    agent_name = "agent#{agent_num}"
    config.vm.define agent_name do |agent|
      # Agents use different memory size than default
      agent.vm.provider "virtualbox" do |v|
        v.memory = AGENT_MEM
      end
      # Define IP
      agent.vm.network :private_network, ip: "10.144.144." + "#{AGENT_IP_RANGE_START+i}"
      # Install mesos and setup mesos-slave
      agent.vm.provision :shell, path: "bootstrap/install_mesos.sh"
      agent.vm.provision "shell", inline: <<-SHELL
        sudo chmod 777 /etc/default/mesos-slave  # XXX hack so that vagrant scp can copy file over
      SHELL
      agent.vm.provision "file", source: "bootstrap/mesos-slave", \
        destination: "/etc/default/mesos-slave"
      agent.vm.provision :shell, path: "bootstrap/agent.sh"
      agent.vm.synced_folder "../enrique", "/home/vagrant/enrique"
    end
  end

  config.vm.define "scheduler" do |scheduler|
    scheduler.vm.network :private_network, ip: "10.144.144.11"
    # We need to install mesos because of required scheduler dependencies
    scheduler.vm.provision :shell, path: "bootstrap/install_mesos.sh"
    scheduler.vm.provision :shell, path: "bootstrap/scheduler.sh"
    scheduler.vm.synced_folder "../faleiro", "/home/vagrant/faleiro"
    scheduler.vm.synced_folder "../miguel", "/home/vagrant/miguel"
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # config.vm.box = "debian/jessie64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL
end
