# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

require 'yaml'
require 'socket'

current_dir = File.dirname(File.expand_path(__FILE__))
if File.file?("#{current_dir}/config.yaml") then
  config_file = YAML.load_file("#{current_dir}/config.yaml")
  # puts 'Loading configuration from config.example.yaml'
else
  config_file = YAML.load_file("#{current_dir}/config.example.yaml")
  puts 'Loading default configuration from config.example.yaml'
  puts 'Copy config.example.yaml to config.yaml and customize configuration for your own environment'
end

if config_file['ssh'].nil? || config_file['ssh']['username'].nil?
  ssh_username = 'vagrant'
else
  ssh_username = config_file['ssh']['username']
end

host_env = ENV.to_h
env = {
    'http_proxy' => host_env['http_proxy'],
    'https_proxy' => host_env['https_proxy'],
    'no_proxy' => host_env['no_proxy'],
    'USER' => ssh_username # La variable d'environment USER n'est pas définie lors du provisionning
}

###############################
# General project settings
# -----------------------------
box_name = 'ubuntu/xenial64'
box_memory = config_file['box_memory'] || 4096
box_cpus = config_file['box_cpus'] || 2
box_cpu_max_exec_cap = config_file['box_cpu_max_exec_cap'] || '90'
disksize = config_file['disksize'] || '40GB'
ip_address = config_file['ip_address'] || '192.168.1.100'
host_network = config_file['host_network']


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

# All Vagrant configuration is done below. The '2' in Vagrant.configure
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

  config.vm.boot_timeout = 600 # default is 300 seconds, but it may be short in some case.

  # SSH connection info
  #config.ssh.username = ssh_username
  #config.ssh.password = ssh_password

  # Configure disk size
  config.disksize.size = disksize

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

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
  config.vm.network 'private_network', ip: ip_address, use_dhcp_assigned_default_route: true
  # config.vm.network "private_network", type: "dhcp"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"
  # config.vm.network 'public_network', type: "dhcp", bridge: host_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |v|
    v.memory = box_memory
    v.cpus = box_cpus
    # v.gui    = true
    v.customize ['modifyvm', :id, '--cpuexecutioncap', box_cpu_max_exec_cap]
    v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    v.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]
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
  if Vagrant.has_plugin?('vagrant-ca-certificates') and not config_file['ca_certificates'].nil?
    config.ca_certificates.enabled = true
    if not config_file['ca_certificates']['ca_certs_glob'].nil?
      config.ca_certificates.certs = Dir.glob(config_file['ca_certificates']['ca_certs_glob'])
    end
    if not config_file['ca_certificates']['ca_certs_file'].nil?
      config.vm.box_download_ca_cert = config_file['ca_certificates']['ca_certs_file']
    end
  end

  persistent_storage = config_file['persistent_storage']
  if Vagrant.has_plugin?('vagrant-persistent-storage') and persistent_storage
    config.persistent_storage.enabled = true
    config.persistent_storage.location = persistent_storage['location']
    config.persistent_storage.size = persistent_storage['size_in_gb'] * 1024
    config.persistent_storage.mountname = 'persistent_storage'
    config.persistent_storage.filesystem = 'ext4'
    config.persistent_storage.mountpoint = "/home/#{ssh_username}/persistent_storage"
    config.persistent_storage.volgroupname = 'persistent_storage'
    config.persistent_storage.diskdevice = '/dev/sdc'
    config.persistent_storage.use_lvm = false
  end

  # Provisioning from files available in provision directory
  config.vm.provision 'prepare', type: 'shell', privileged: false, path: 'provision/01-prepare.sh', env: env

  config.vm.provision 'environment-variables', type: 'shell', privileged: false, path: 'provision/03-environment-variables.sh', env: env

  config.vm.provision 'jq', type: 'shell', privileged: true, path: 'provision/05-jq.sh', env: env
  
  config.vm.provision 'cfssl-cli', type: 'shell', path: 'provision/07-cfssl-cli.sh', env: env

  config.vm.provision 'docker', type: 'shell', path: 'provision/11-docker.sh', env: env
  config.vm.provision 'docker-group', type: 'shell', path: 'provision/13-docker-group.sh', env: env

  if Vagrant.has_plugin?('vagrant-reload')
    config.vm.provision :reload
  end

  config.vm.provision 'docker-compose', type: 'shell', path: 'provision/21-docker-compose.sh', env: env

  config.vm.provision 'container-nginx-proxy', type: 'shell', privileged: false, path: 'provision/31-container-nginx-proxy.sh', env: env

  config.vm.provision 'container-portainer', type: 'shell', privileged: false, path: 'provision/32-container-portainer.sh', env: env

  config.vm.provision 'smartcd', type: 'shell', privileged: false, path: 'provision/41-smartcd.sh', env: env

  config.vm.provision 'node', type: 'shell', privileged: false, path: 'provision/46-node.sh', env: env
  config.vm.provision 'yeoman', type: 'shell', privileged: false, path: 'provision/47-yeoman.sh', env: env

  config.vm.provision 'vpnc', type: 'shell', path: 'provision/51-vpnc.sh', env: env

  if File.file?(File.join(Dir.home, '.ssh/id_rsa.pub')) or File.file?(File.join(Dir.home, '.ssh/id_rsa'))
    if File.file?(File.join(Dir.home, '.ssh/id_rsa'))
      config.vm.provision 'ssh-keys-private', type: 'file', source: '~/.ssh/id_rsa', destination: "/home/#{ssh_username}/.provision/id_rsa"
    end
    if File.file?(File.join(Dir.home, '.ssh/id_rsa.pub'))
      config.vm.provision 'ssh-keys-public', type: 'file', source: '~/.ssh/id_rsa.pub', destination: "/home/#{ssh_username}/.provision/id_rsa.pub"
    end
    config.vm.provision 'ssh-keys', type: 'shell', privileged: false, path: 'provision/61-ssh-keys.sh', env: env
  end

  config.vm.provision 'cleanup', type: 'shell', path: 'provision/99-cleanup.sh', env: env

  if not config_file['env'].nil?
    config.vm.provision "shell", inline: "> /etc/profile.d/vagrant-env.sh", privileged: true, run: "always"

    config_file['env'].each do |key, value|
      config.vm.provision "shell", inline: "echo export #{key}=\\\"#{value}\\\">> /etc/profile.d/vagrant-env.sh", privileged: true, run: "always"
    end
  else
    config.vm.provision "shell", inline: "rm -f /etc/profile.d/vagrant-env.sh", privileged: true, run: "always"
  end

  # Disable vagrant default share
  config.vm.synced_folder '.', '/vagrant', disabled: true

  synced_folders = config_file['synced_folders']
  if Vagrant.has_plugin?('vagrant-nfs4j') and synced_folders
    config.nsf4j.logging = 'off'
    config.nsf4j.uid = 1000
    config.nsf4j.gid = 1000

    synced_folders.each do |i, folder|
      mount_options = if folder.key?('mount_options') then
                        folder['mount_options']
                      else
                        %w(nolock udp noatime nodiratime actimeo=1)
                      end
      mount_options = if not mount_options or mount_options.kind_of?(Array) then
                        mount_options
                      else
                        mount_options.split(/[,\s]/)
                      end

      config.vm.synced_folder "#{folder['source']}", if folder['target'].start_with?("/") then
                                                       folder['target']
                                                     else
                                                       "/home/#{ssh_username}/#{folder['target']}"
                                                     end,
                              id: "#{i}",
                              type: 'nfs',
                              mount_options: mount_options
      # See https://www.sebastien-han.fr/blog/2012/12/18/noac-performance-impact-on-web-applications/
    end
  end
end
