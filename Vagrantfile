# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant API version
VAGRANTFILE_API_VERSION = '2'

if File.file?('config/config.rb')
  require_relative 'config/config.rb'
end

VIRTUAL_MACHINE_IP= '192.168.2.100' unless defined? VIRTUAL_MACHINE_IP
VIRTUAL_MACHINE_MEMORY = '2048' unless defined? VIRTUAL_MACHINE_MEMORY
GIT_CONFIG_FILE = '~/.gitconfig' unless defined? GIT_CONFIG_FILE
GIT_IGNORE_FILE = '~/.gitignore' unless defined? GIT_IGNORE_FILE
SSH_PATH = '~/.ssh' unless defined? SSH_PATH

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.hostname = 'hitttenDevWebServer'
  config.vm.network 'private_network', ip: VIRTUAL_MACHINE_IP
  config.vm.network 'forwarded_port', guest: 80, host: 80
  config.ssh.forward_agent = true

  windows_host = (RUBY_PLATFORM =~ /mingw/) ? true : false

  if windows_host #verify is if a windows host
    config.vm.synced_folder '.', '/vagrant', type: 'smb' #, :mount_options => ['dmode=775', 'fmode=664'] #TODO: vagrant ask password for admin user, this return "Error! Your console doesn't support hiding input. We'll ask for input again below, but we WILL NOT be able to hide input. If this is a problem for you, ctrl-C to exit and fix your stdin."
    config.vm.synced_folder '../..', '/home/ubuntu/Workspace', type: 'smb' #, :mount_options => ['dmode=775', 'fmode=664']
  else
    config.vm.synced_folder '../..', '/home/ubuntu/Workspace', type: 'nfs', :mount_options => ['actimeo=2', 'rw', 'vers=3', 'tcp', 'fsc']
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1']
    vb.customize ['modifyvm', :id, '--memory', VIRTUAL_MACHINE_MEMORY]
    vb.name = 'hittten_dev_web_server'
  end

  if File.exists? File.expand_path(GIT_CONFIG_FILE)
    config.vm.provision 'file', source: GIT_CONFIG_FILE, destination: '.gitconfig'
  end

  if File.exists? File.expand_path(GIT_IGNORE_FILE)
    config.vm.provision 'file', source: GIT_IGNORE_FILE, destination: '.gitignore'
  end

  if File.exists? File.expand_path(SSH_PATH)
    config.vm.provision 'shell', inline: 'chmod -f 664 .ssh/*; true'
    Dir.foreach(File.expand_path(SSH_PATH)) do |item|
      next if item == '.' or item == '..'
      config.vm.provision 'file', source: SSH_PATH + '/' +item, destination: '.ssh/' + item
    end
    config.vm.provision 'shell', path: 'fix_ssh_permissions.sh'
  end

  provision = 'ansible'
  if windows_host #verify is if a windows host
    provision = 'ansible_local'
  end

  config.vm.provision provision do |ansible|
    ansible.playbook = 'provision/vagrant.yml'
    if File.file?('config/projects.yml')
      ansible.extra_vars = 'config/projects.yml'
    end
    if windows_host #verify is if a windows host
      ansible.install = true
    end
  end

  if File.file?('config/projects.yml')
    config.vm.provision provision do |ansible|
      ansible.playbook = 'provision/.projects.yml'
    end
  end
end
