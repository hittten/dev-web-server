# Ubuntu trusty 64 virtual environment for web apps via Vagrant.
Vagrant is a tool for building complete development environments. With an easy-to-use workflow and focus on automation, Vagrant lowers development environment setup time, increases development/production parity, and makes the "works on my machine" excuse a relic of the past. 

## 1. Dependencies
You must have installed the following tools in order to work:

+ [VirtualBox](https://www.virtualbox.org/)
+ [Vagrant](https://www.vagrantup.com/)
+ [Git](https://git-scm.com/)

## 2. How to install dependencies?
### Ubuntu/Debian Linux Download and install:
```bash
sudo apt-get install software-properties-common
sudo apt-get update
sudo apt-get install git vagrant ansible virtualbox virtualbox-guest-additions-iso
```

### OSX Download and install:
#### a. Traditional way
- [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
- [https://git-scm.com/download/mac](https://git-scm.com/download/mac)

#### b. HomeBrew way [http://brew.sh/](http://brew.sh/)
```bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install caskroom/cask/brew-cask
brew cask install vagrant
brew cask install virtualbox
brew install ansible
```

### Windows Download and install:
- [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
- [https://git-scm.com/download/win](https://git-scm.com/download/win)

## 3. How to use it?
I recommend this directory structure:
```
Workspace/
├── hittten/
|     ├── dev-server/
|     ├──  .
|     ├──  .
|     └── another-web-project/
├──  .
├──  .
└── another-vendor/
      └── another-web-project/
```
- Open a terminal (if you are using windows open git-bash as an Administrator. [Why?](https://www.vagrantup.com/docs/synced-folders/smb.html))
- Go to your workspace directory
```bash
mkdir hittten
cd hittten
git clone git@github.com:hittten/dev-web-server.git
cd dev-web-server # Note: you always have to be in this directory to run these commands

vagrant up         #To start the virtual machine
vagrant ssh        #To connect to the virtual machine
vagrant reload     #To restart the virtual machine
vagrant halt       #To turn off the virtual machine (always turn off your virtual machine before restart or shutdown your host computer)
vagrant destroy    #To delete the virtual machine (you can use this if you have any problem with your machine and start over with a "vagrant up")
```
- For more commands see: [https://www.vagrantup.com/docs/cli/](https://www.vagrantup.com/docs/cli/)

Then in your host machine you can use any IDE software to develop in your Workspace directory and you will see all these projects in your virtual machine (~/Workspace)

## 4. Custom config
Open the Vagrantfile in the root directory
```ruby
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
```
