# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
config = YAML.load_file("#{current_dir}/config.yaml")

host_env = ENV.to_h
env = {
    "http_proxy" => host_env['http_proxy'],
    "https_proxy" => host_env['https_proxy'],
    "no_proxy" => host_env['no_proxy'],
    "USER" => 'ubuntu' # La variable d'environment USER n'est pas définie lors du provisionning
}

###############################
# General project settings
# -----------------------------
box_name = "ubuntu/xenial64"
box_memory = config['box_memory'] || 2048
box_cpus = config['box_cpus'] || 2
box_cpu_max_exec_cap = config['box_cpu_max_exec_cap'] || "90"
disksize = config['disksize'] || '20GB'
host_network = config['host_network']

ip_address = "192.168.1.100"

def self.get_host_ip(connect_ip)
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
  UDPSocket.open do |s|
    s.connect connect_ip, 1
    s.addr.last
  end
  ensure
    Socket.do_not_reverse_lookup = orig
end

env['HOST_IP'] = get_host_ip(ip_address)

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |conf|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  conf.vm.box = box_name

  # Configure disk size
  conf.disksize.size = disksize

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
  conf.vm.network "private_network", ip: ip_address, use_dhcp_assigned_default_route: true
  # config.vm.network "private_network", type: "dhcp"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  conf.vm.network "public_network", type: "dhcp", bridge: host_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  conf.vm.provider "virtualbox" do |v|
    v.memory = box_memory
    v.cpus = box_cpus
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
  # config.vm.provision "shell", inline: <<-SHELL
  # SHELL

  # Proxy configuration
  if Vagrant.has_plugin?("vagrant-proxyconf")
    if host_env['http_proxy']
      conf.proxy.http = host_env['http_proxy']
    end
    if host_env['https_proxy']
      conf.proxy.https = host_env['https_proxy']
    end
    if host_env['no_proxy']
      conf.proxy.no_proxy = host_env['no_proxy']
    end
  elsif host_env['http_proxy'] or host_env['https_proxy']
    puts 'vagrant-proxyconf plugin is not installed. Vagrant box will not be configured to use host configured HTTP proxy.'
  end

  # Provisioning from files available in provision directory
  conf.vm.provision "system-settings", type: "shell", path: "provision/02-system-settings.sh", env: env
  conf.vm.provision "environment-variables", type: "shell", privileged: false, path: "provision/03-environment-variables.sh", env: env

  conf.vm.provision "docker", type: "shell", path: "provision/11-docker.sh", env: env
  conf.vm.provision "docker-group", type: "shell", path: "provision/13-docker-group.sh", env: env

  conf.vm.provision "docker-compose", type: "shell", path: "provision/21-docker-compose.sh", env: env

  conf.vm.provision "container-nginx-proxy", type: "shell", privileged: false, path: "provision/31-container-nginx-proxy.sh", env: env

  conf.vm.provision "smartcd", type: "shell", privileged: false, path: "provision/41-smartcd.sh", env: env

  conf.vm.provision "smartcd", type: "shell", path: "provision/51-vpnc.sh", env: env

  synced_folders = config["synced_folders"]
  if synced_folders
    if Vagrant.has_plugin?("vagrant-winnfsd")
      conf.winnfsd.logging = "off"
      conf.winnfsd.uid = 1000
      conf.winnfsd.gid = 1000
      conf.winnfsd.halt_on_reload = "on"

      synced_folders.each do |i,folder|
        conf.vm.synced_folder "#{folder['source']}", "#{folder['target']}",
                              id: "#{i}",
                              type: 'nfs',
                              :nfs => { :mount_options => ["#{folder['mount_options']}" || nil] }
      end
    else
      puts 'vagrant-winnfsd plugin is not installed, nfs shares won\'t be available. run "vagrant plugin install vagrant-winnfsd" to install the plugin.'
    end
  end
end