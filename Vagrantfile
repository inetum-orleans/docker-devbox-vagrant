# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

require 'yaml'
require 'socket'

current_dir = File.dirname(File.expand_path(__FILE__))
if File.file?("#{current_dir}/config.yaml")
then
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
    'USER' => ssh_username, # La variable d'environment USER n'est pas définie lors du provisionning
    'CONFIG_LOCALE' => 'fr_FR.UTF-8',
    'CONFIG_LANGUAGE' => 'fr_FR',
    'CONFIG_KEYBOARD_LAYOUT' => 'fr',
    'CONFIG_KEYBOARD_VARIANT' => 'latin9',
    'CONFIG_TIMEZONE' => 'Europe/Paris'
}

def self.get_host_ip(connect_ip)
  orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
  UDPSocket.open do |s|
    s.connect connect_ip, 1
    s.addr.last
  end
ensure
  Socket.do_not_reverse_lookup = orig
end

###############################
# General project settings
# -----------------------------
box_name = config_file['box_name'] || 'ubuntu/bionic64'
box_memory = config_file['box_memory']
box_cpus = config_file['box_cpus']
box_cpu_max_exec_cap = config_file['box_cpu_max_exec_cap']
box_video_ram = config_file['box_video_ram']
box_monitor_count = config_file['box_monitor_count']
disksize = config_file['disksize']
ip_address = config_file['ip_address'] || '192.168.99.100'
host_ip_address = config_file['host_ip_address'] || get_host_ip(ip_address)
desktop = config_file['desktop'] || false
gui = desktop || config_file['gui'] || false
provision_options = config_file['provision_options'] || []

env['HOST_IP'] = host_ip_address
env['LOCAL_IP'] = ip_address

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
  #config.vm.box_download_insecure = true

  config.vm.boot_timeout = 600 # default is 300 seconds, but it may be short in some case.

  # SSH connection info
  #config.ssh.username = ssh_username
  #config.ssh.password = ssh_password

  # Configure disk size
  if Vagrant.has_plugin?('vagrant-disksize') and disksize
    config.disksize.size = disksize
  end

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
  config.vm.network 'private_network', ip: ip_address
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
    unless box_memory.nil?
      v.memory = box_memory
    end

    unless box_cpus.nil?
      v.cpus = box_cpus
    end

    v.gui = gui

    unless box_video_ram.nil?
      v.customize ["modifyvm", :id, "--vram", box_video_ram]
    end

    unless box_cpu_max_exec_cap.nil?
      v.customize ['modifyvm', :id, '--cpuexecutioncap', box_cpu_max_exec_cap]
    end

    unless box_monitor_count.nil?
      v.customize ['modifyvm', :id, '--monitorcount', box_monitor_count]
    end

    v.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 1000]

    # Uncomment following lines if you experience DNS issues inside VM
    # v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    # v.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
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

  # Workaround for https://github.com/dotless-de/vagrant-vbguest/issues/337
  if Vagrant.has_plugin?("vagrant-vbguest")
    # Check for and install VB Guest Additions only on the very first provision
    # To update virtualbox guest additions, run "vagrant vbguest --do install"
    # Waiting for next release, it should be fixed 0.17.3 or 0.18.0
    # See https://github.com/dotless-de/vagrant-vbguest/pull/334
    config.vbguest.auto_update = !Dir['.vagrant/machines/default/*/action_provision'].any?
  end

  # CA Certificates configuration
  # vagrant-certificates is a fork of default vagrant-ca-certificates, fixing and issue for vagrant >= 2.2.4
  # https://github.com/gfi-centre-ouest/vagrant-certificates
  if (Vagrant.has_plugin?('vagrant-certificates') or Vagrant.has_plugin?('vagrant-ca-certificates')) and not config_file['ca_certificates'].nil?
    ca_certificates_config = Vagrant.has_plugin?('vagrant-ca-certificates') ? config.ca_certificates : config.certificates

    ca_certificates_config.enabled = true
    unless config_file['ca_certificates']['ca_certs_glob'].nil?
      ca_certificates_config.certs = Dir.glob(config_file['ca_certificates']['ca_certs_glob'])
    end
    unless config_file['ca_certificates']['ca_certs_file'].nil?
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

  if not config_file['env'].nil?
    config.vm.provision 'shell', inline: "> /etc/profile.d/vagrant-env.sh", privileged: true, env: env, run: 'always'

    config_file['env'].each do |key, value|
      config.vm.provision 'shell', inline: "echo export #{key}=\\\"#{value}\\\">> /etc/profile.d/vagrant-env.sh", privileged: true, env: env, run: 'always'
    end
  else
    config.vm.provision 'shell', inline: "rm -f /etc/profile.d/vagrant-env.sh", privileged: true, env: env, run: 'always'
  end

  # Provisioning from files available in provision directory
  config.vm.provision 'prepare', type: 'shell', privileged: false, path: 'provision/01-prepare.sh', env: env

  config.vm.provision 'locale', type: 'shell', privileged: false, path: 'provision/02-locale.sh', env: env

  config.vm.provision 'environment-variables', type: 'shell', privileged: false, path: 'provision/03-environment-variables.sh', env: env, run: "always"
  config.vm.provision 'system-variables', type: 'shell', privileged: true, path: 'provision/04-system-variables.sh', env: env, run: "always"
  config.vm.provision 'dnsmasq', type: 'shell', privileged: true, path: 'provision/05-dnsmasq.sh', env: env, run: "always"

  config.vm.provision :docker
  config.vm.provision 'docker-config', type: 'shell', path: 'provision/13-docker-config.sh', env: env
  config.vm.provision 'docker-compose', type: 'shell', path: 'provision/21-docker-compose.sh', env: env

  config.vm.provision 'docker-devbox', type: 'shell', privileged: false, path: 'provision/31-docker-devbox.sh', env: env
  config.vm.provision 'ddb', type: 'shell', privileged: false, path: 'provision/32-ddb.sh', env: env, run: 'always'

  config.vm.provision 'node', type: 'shell', privileged: false, path: 'provision/46-node.sh', env: env
  config.vm.provision 'yeoman', type: 'shell', privileged: false, path: 'provision/47-yeoman.sh', env: env

  config.vm.provision 'gitconfig', type: 'shell', path: 'provision/55-gitconfig.sh', env: env

  if File.file?(File.join(Dir.home, '.ssh/id_rsa.pub')) or File.file?(File.join(Dir.home, '.ssh/id_rsa'))
    config.vm.provision 'ssh-keys-private', type: 'file', source: '~/.ssh/id_rsa', destination: "/home/#{ssh_username}/.provision/id_rsa", run: "always"
    config.vm.provision 'ssh-keys-public', type: 'file', source: '~/.ssh/id_rsa.pub', destination: "/home/#{ssh_username}/.provision/id_rsa.pub", run: "always"
    config.vm.provision 'ssh-keys', type: 'shell', privileged: false, path: 'provision/61-ssh-keys.sh', env: env, run: "always"
  end

  config.vm.provision 'cleanup', type: 'shell', path: 'provision/99-cleanup.sh', env: env

  # Install desktop environement
  if desktop
    config.vm.provision 'desktop', type: 'shell', privileged: false, path: 'provision/71-desktop.sh', env: env

    config.vm.provision 'desktop-additions', type: 'shell', privileged: false, path: 'provision/79-desktop-additions.sh', env: env

    # Restart resolvconf for dns problems ...
    # config.vm.provision "shell", privileged: true, inline: "resolvconf -u", run: 'always'
  end

  # The following provisionners can be executed manually with "vagrant provision --provision-with"
  Dir.glob('provision/options/*') do |file|
    run = "never" 
    option = File.basename(file, ".*" )
    if provision_options.include? option
      run = nil
    end
    config.vm.provision option, type: 'shell', privileged: false, path: file, env: env, run: run
  end

  # Restart docker.socket service because of unknown failure on vagrant startup or reload ...
  config.vm.provision "shell", privileged: true, inline: "systemctl restart docker.socket", env: env, run: 'always'

  # Disable vagrant default share
  config.vm.synced_folder '.', '/vagrant', disabled: true

  synced_folders = config_file['synced_folders']

  if synced_folders
    synced_folders_plugin = config_file['synced_folders_plugin']
    default_mount_options = nil

    if Vagrant.has_plugin?('vagrant-nfs4j') and (not synced_folders_plugin or synced_folders_plugin === 'nfs4j')
      synced_folders_plugin = 'nfs4j'
      config.nfs4j.shares_config = {:permissions => {:uid => 1000, :gid => 1000}}
    end

    if Vagrant.has_plugin?('vagrant-winnfsd') and (not synced_folders_plugin or synced_folders_plugin === 'winnfsd')
      synced_folders_plugin = 'winnfsd'
      config.winnfsd.logging = 'off'
      config.winnfsd.uid = 1000
      config.winnfsd.gid = 1000
      default_mount_options = %w(nolock udp noatime nodiratime actimeo=1)
    end

    if %w(winnfsd nfs4j).include? synced_folders_plugin
      synced_folders.each do |i, folder|
        mount_options = folder.key?('mount_options') ? folder['mount_options'] : default_mount_options
        mount_options = if not mount_options or mount_options.kind_of?(Array)
        then
                          mount_options
                        else
                          mount_options.split(/[,\s]/)
                        end

        config.vm.synced_folder "#{folder['source']}",
                                folder['target'].start_with?("/") ? folder['target'] : "/home/#{ssh_username}/#{folder['target']}",
                                id: "#{i}",
                                type: 'nfs',
                                mount_options: mount_options
      end
    else
      synced_folders.each do |i, folder|
        config.vm.synced_folder "#{folder['source']}",
                                folder['target'].start_with?("/") ? folder['target'] : "/home/#{ssh_username}/#{folder['target']}",
                                id: "#{i}"
      end
    end
  end
end
