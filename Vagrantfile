# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant API version
VAGRANTFILE_API_VERSION = '2'

# Set the ip machine in order to work with your router gateway.
# You can set almost any IP depend of your router configuration.
# Example: router gateway: 192.168.1.1 => 192.168.2.xxx (the 2 can be any number except 1)
# Example: router gateway: 10.1.1.1 => 10.1.2.xxx (the 2 can be any number except 1)

# Note: if you don't have any special config in your router, you can leave the default value.
VIRTUAL_MACHINE_IP = '192.168.2.100'

# The memory RAM of your virtual machine
VIRTUAL_MACHINE_MEMORY = '2048'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'ubuntu/trusty64'
  config.vm.hostname = 'hitttenDevWebServer'
  config.vm.network 'private_network', ip: VIRTUAL_MACHINE_IP
  config.ssh.forward_agent = true

  windows_host = (RUBY_PLATFORM =~ /mingw/) ? true : false

  if windows_host #verify is if a windows host
    config.vm.synced_folder '.', '/vagrant', type: 'smb' #, :mount_options => ['dmode=775', 'fmode=664'] #TODO: vagrant ask password for admin user, this return "Error! Your console doesn't support hiding input. We'll ask for input again below, but we WILL NOT be able to hide input. If this is a problem for you, ctrl-C to exit and fix your stdin."
    config.vm.synced_folder '../..', '/home/vagrant/Workspace', type: 'smb' #, :mount_options => ['dmode=775', 'fmode=664']
  else
    config.vm.synced_folder '../..', '/home/vagrant/Workspace', type: 'nfs', :mount_options => ['actimeo=2', 'rw', 'vers=3', 'tcp', 'fsc']
  end

  config.vm.provider 'virtualbox' do |vb|
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root', '1']
    vb.customize ['modifyvm', :id, '--memory', VIRTUAL_MACHINE_MEMORY]
    vb.name = 'hittten_dev_web_server'
  end
end
