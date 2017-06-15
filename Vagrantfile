# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
shared         = YAML.load_file("#{current_dir}/shared.yaml")
shared_folders = shared['folders']

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

###############################
# General project settings
# -----------------------------
box_name             = "ubuntu/xenial64"
box_memory           = 4096
box_cpus             = 3
box_cpu_max_exec_cap = "90"

ip_address = "192.168.1.100"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = box_name

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: ip_address, use_dhcp_assigned_default_route: true
  # config.vm.network "private_network", type: "dhcp"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  config.vm.network "public_network", type: "dhcp"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |v|
    v.memory = box_memory
    v.cpus   = box_cpus
    # v.gui    = true
    v.customize ["modifyvm", :id, "--cpuexecutioncap", box_cpu_max_exec_cap]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
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
  config.vm.provision "shell", inline: <<-SHELL
    # ENV VARS + PROXY GFI
    echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games' > /etc/environment
    echo 'http_proxy=http://webdefence.global.blackspider.com:80' >> /etc/environment
    echo 'https_proxy=http://webdefence.global.blackspider.com:80' >> /etc/environment
    echo 'no_proxy=localhost,127.0.0.1,192.168.99.100,frordvmf002,gitlab,glbaso01.asogfi.fr' >> /etc/environment
    echo 'HTTP_PROXY=http://webdefence.global.blackspider.com:80' >> /etc/environment
    echo 'HTTPS_PROXY=http://webdefence.global.blackspider.com:80' >> /etc/environment
    echo 'NO_PROXY=localhost,127.0.0.1,192.168.99.100,frordvmf002,gitlab,glbaso01.asogfi.fr' >> /etc/environment
    # GROUP FOR DOCKER
    sudo groupadd docker
    sudo usermod -aG docker $USER
  SHELL

  # trigger reload
  # config.vm.provision :reload

  # Provisionong shell
  config.vm.provision "shell", path: "provision.sh"

  #UNISON

  # Required configs
   config.unison.host_folder = "../AFB/PATBiodiv/www"  #relative to the folder your Vagrantfile is in
   config.unison.guest_folder = "/home/vagrant/workspace/AFB/PATBiodiv" #relative to the vagrant home folder (e.g. /home/vagrant)

   # Optional configs
   # File patterns to ignore when syncing. Ensure you don't have spaces between the commas!
   config.unison.ignore = "Name {.DS_Store,.git,node_modules,.idea}" # Default: none

   # SSH connection details for Vagrant to communicate with VM.
  #  config.unison.ssh_host = "127.0.0.1" # Default: '127.0.0.1'
  #  config.unison.ssh_port = 2222 # Default: 2222
   config.unison.ssh_user = "ubuntu" # Default: 'vagrant'
  #  config.unison.perms = 0 # if you get "properties changed on both sides" error

   # `vagrant unison-sync-polling` command will restart unison in VM if memory
   # usage gets above this threshold (in MB).
   config.unison.mem_cap_mb = 500 # Default: 200

   # Change polling interval (in seconds) at which to sync changes
   config.unison.repeat = 5 # Default: 1

   # WINNFSD
   config.winnfsd.logging="off"
   config.winnfsd.uid=501
   config.winnfsd.gid=48
   config.winnfsd.halt_on_reload="on"

   # Iterate through entries in YAML file
   shared_folders.each do |i,folder|
     config.vm.synced_folder "#{folder['source']}", "#{folder['target']}",
      id: "#{i}",
      type: 'nfs',
      :nfs => { :mount_options => ['dmode=775,fmode=775,nolock,vers=3,udp,noatime,actimeo=1'] }
   end

end
