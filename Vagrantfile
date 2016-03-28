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

  NUM_SCHEDULERS = 3
  SCHED_IP_RANGE_START = 20
  SCHEDULER_MEM = 384

  config.landrush.enabled = true

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
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "10.144.144.10"
    master.vm.provision :shell, path: "bootstrap/install_mesos.sh"

    # Set the mesos-master config file
    mesos_master_config = [
      "rm /etc/default/mesos-master",
      "echo \"PORT=5050\" >> /etc/default/mesos-master",
      "echo \"ZK=`cat /etc/mesos/zk`\" >> /etc/default/mesos-master",
      "echo \"IP=10.144.144.10\" >> /etc/default/mesos-master"
    ].join("\n") + "\n"
    master.vm.provision :shell, inline: mesos_master_config

    master.vm.provision :shell, path: "bootstrap/master.sh"
  end

  if NUM_AGENTS > 254-AGENT_IP_RANGE_START
    raise "Too many agents"
  end
  (1..NUM_AGENTS).each do |i|
    agent_num = "#{i}".rjust(3, '0')
    agent_name = "agent#{agent_num}"
    config.vm.define agent_name do |agent|
      agent.vm.hostname = agent_name
      # Agents use different memory size than default
      agent.vm.provider "virtualbox" do |v|
        v.memory = AGENT_MEM
      end
      # Define IP
      agent_ip = "10.144.144." + "#{AGENT_IP_RANGE_START+i}"
      agent.vm.network :private_network, ip: agent_ip
      # Install mesos and setup mesos-slave
      agent.vm.provision :shell, path: "bootstrap/install_mesos.sh"

      # Set the mesos-slave config file
      mesos_slave_config = [
        "rm /etc/default/mesos-slave",
        "echo \"MASTER=10.144.144.10:5050\" >> /etc/default/mesos-slave",
        "echo \"PORT=5041\" >> /etc/default/mesos-slave",
        "echo \"IP=#{agent_ip}\" >> /etc/default/mesos-slave"
      ].join("\n") + "\n"
      agent.vm.provision :shell, inline: mesos_slave_config

      agent.vm.provision :shell, path: "bootstrap/agent.sh"
      agent.vm.synced_folder "../enrique", "/home/vagrant/enrique"
    end
  end


  def configure_scheduler(i, scheduler, hostname, ip_address)
    scheduler.vm.hostname = hostname
    # Schedulers use different memory size than default
    scheduler.vm.provider "virtualbox" do |v|
      v.memory = SCHEDULER_MEM
    end
    scheduler.vm.network :private_network, ip: ip_address
    # We need to install mesos because of required scheduler dependencies
    scheduler.vm.provision :shell, path: "bootstrap/install_mesos.sh"
    scheduler.vm.provision :shell, path: "bootstrap/scheduler/scheduler.sh"
    scheduler.vm.provision :shell, path: "bootstrap/scheduler/config.sh"
    scheduler.vm.provision :shell,
      path: "bootstrap/scheduler/zookeeper_config.sh",
      args: "-n #{NUM_SCHEDULERS} -r #{SCHED_IP_RANGE_START} -i #{i}"
    scheduler.vm.provision :shell, path: "bootstrap/scheduler/scheduler_post.sh"
    scheduler.vm.synced_folder "../faleiro", "/home/vagrant/faleiro"
    scheduler.vm.synced_folder "../miguel", "/home/vagrant/miguel"
  end

  (1..NUM_SCHEDULERS).each do |i|
    sched_num = "#{i}".rjust(3, '0')
    sched_name = "scheduler#{sched_num}"
    sched_ip = "10.144.144." + "#{SCHED_IP_RANGE_START+i}"
    config.vm.define sched_name do |scheduler|
      configure_scheduler(i, scheduler, sched_name, sched_ip)
    end
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
