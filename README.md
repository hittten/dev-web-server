# Ubuntu xenial 64 virtual environment for web apps via Vagrant provisioned with Ansible.
**Vagrant** is a tool for building complete development environments. With an easy-to-use workflow and focus on automation, Vagrant lowers development environment setup time, increases development/production parity, and makes the "works on my machine" excuse a relic of the past. 

**Ansible** is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks such as continuous deployments or zero downtime rolling updates.

## What do you get?
A Virtualbox virtual machine with Ubuntu Trusty64 provisioned with this:

+ **Common Role:**
    - git
    - curl
    - wget
    - ntp
    - vim
    - htop
    - sendmail
    - lynx
    - dot files: [~/.bash_aliases](provision/roles/common/files/dotfiles/.bash_aliases), [~/.bash_colors](provision/roles/common/files/dotfiles/.bash_colors), [~/.bashrc](provision/roles/common/files/dotfiles/.bashrc)
    - A copy of your local .gitconfig, .gitignore and .ssh folder
+ **Webtier Role:**
    - apache2 with modules: _actions, alias, fastcgi, rewrite, ssl, wsgi_
    - php with packages: _php-dev, php-pear, php-xdebug, php-curl, php-mcrypt, php-imagick, php-intl, php-gd, phpunit, php-mongodb, php-mysql, php-mbstring, php-zip, php-bcmath_
    - python with packages: _python-setuptools, python-mysqldb, python-pip, python-virtualenv_
    - npm with components: _bower, gulp-cli, grunt-cli, live-server_
    - ruby with packages: _ruby-bundler_
    - composer
    - nodejs
    - Oracle Java
+ **DBtier Role:**
    - MySQL
    - MongoDB
    - ElasticSearch
+ **Webproject Role:**
    - Clone repositories
    - SSL apache config
    - Apache virtual host config
    - Shell script

## 1. Dependencies
You must have installed the following tools in order to work:

+ [VirtualBox](https://www.virtualbox.org/)
+ [Vagrant](https://www.vagrantup.com/)
+ [Git](https://git-scm.com/)
+ [Ansible](http://docs.ansible.com/)

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
- [http://docs.ansible.com/ansible/intro_installation.html#latest-releases-on-mac-osx](http://docs.ansible.com/ansible/intro_installation.html#latest-releases-on-mac-osx)

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
- Ansible is not compatible with Windows, so do not install it. Don't worry the virtual machine will be provisioned with an ansible installed locally in the virtual machine.

## 3. How to use it?
I recommend this directory structure:
```
Workspace/
├── hittten/
|     ├── dev-server/
|     ├──   .
|     ├──   .
|     └── another-web-project/
├──   .
├──   .
└── another-vendor/
      └── another-web-project/
```
- Open a terminal (if you are using windows open git-bash as an Administrator. [Why?](https://www.vagrantup.com/docs/synced-folders/smb.html))
- Go to your workspace directory
```bash
mkdir hittten
cd hittten
git clone git@github.com:hittten/dev-web-server.git
```
- Setup your projects config file:
Create _**projects.yml**_ in the config directory _**(../dev-web-server/config/projects.yml)**_ and build your projects:

Parameter | Type | Required | Default | Comments
--------- | ---- | -------- | ------- | --------
domain | string | Yes | None | Apache ServerName.<br />See [ServerName Directiva](https://httpd.apache.org/docs/2.4/mod/core.html#servername) and [VirtualHost Examples](https://httpd.apache.org/docs/2.4/vhosts/examples.html).
ssl | string | Yes | None | Only options: `'false'` or `'true'`. <br />**Note:** If there are no single quotes, it will not work.
workspace | string | Yes | None | Path of the project code.
host | string | No | `'*:80'` or `'*:443'` depends of ssl parameter. | This parameter will be in \<VirtualHost `host`\>.<br />See [VirtualHost Directiva](https://httpd.apache.org/docs/2.4/mod/core.html#virtualhost) and [VirtualHost Examples](https://httpd.apache.org/docs/2.4/vhosts/examples.html).
public_html | string | No | same workspace parameter | Path to the project folder that is public from the browser.<br />See [Directory Directiva](http://httpd.apache.org/docs/current/mod/core.html#directory)
repository | string | No | None | git, SSH, or HTTP(S) protocol address of the git repository.
version | string | when repository is defined | None | What version of the repository to check out. This can be the the literal string `HEAD`, a branch name, a tag name.

_config/projects.yml_ example:
```yml

---
projects:
    - {
      domain: 'local.domain.com',
      ssl: 'false',
      repository: 'git@github.com:vendor/repository.git',
      version: 'dev',
      workspace: '/home/vagrant/Workspace/vendor/domain.com',
      public_html: '/home/vagrant/Workspace/vendor/domain.com/web',
      script: 'cd /home/vagrant/Workspace/vendor/domain.com && yes | composer install --no-interaction'
    }
    - {
      domain: 'local.other.domain.com',
      ssl: 'true',
      workspace: '/home/vagrant/Workspace/vendor/other.domain.com',
    }
```
- If you build a project with ssl, you must put the crt file and key file in _**(../dev-web-server/config/ssl/)**_ path with the same name of the `domain` parameter:
    * dev-web-server/config/ssl/other.domain.com.dev.crt
    * dev-web-server/config/ssl/other.domain.com.dev.key
- Edit your local hosts file: **Windows**: _C:\Windows\System32\drivers\etc\hosts_, **Linux**: _/etc/hosts_ or **OSX**: _/etc/hosts_:
    * Add new line with your domains projects `192.168.2.100 domain.com.dev`

```bash
cd dev-web-server # Note: you always have to be in this directory to run these commands

#To manage the virtual machine
vagrant up              #To start the virtual machine.
vagrant ssh             #To connect to the virtual machine.
vagrant reload          #To restart the virtual machine.
vagrant status          #To see the status of virtual machine.
vagrant halt            #To turn off the virtual machine (always turn off your virtual machine before restart or shutdown your host computer).
vagrant destroy         #To delete the virtual machine (you can use this if you have any problem with your machine and start over with a "vagrant up").

#To manage provision
vagrant up --provision  #When you do vagrant up in a first time the ansible will provisioned the machine automatically, if you need reprovision you can use this command with the machine off
vagrant provision       #When you do vagrant up in a first time the ansible will provisioned the machine automatically, if you need reprovision you can use this command with the machine on
```
- When the provision finish you can open http//domain.com.dev and see your web project
- For more commands see: [https://www.vagrantup.com/docs/cli/](https://www.vagrantup.com/docs/cli/)

Then in your host machine you can use any IDE software to develop in your Workspace directory and you will see all these projects in your virtual machine (~/Workspace)

## 4. Custom config
Create _**config.rb**_ in the config directory _**(../dev-web-server/config/config.rb)**_, copy and paste this:
```ruby
# Set the ip machine in order to work with your router gateway.
# You can set almost any IP depend of your router configuration.
# Example: router gateway: 192.168.1.1 => 192.168.2.xxx (the 2 can be any number except 1)
# Example: router gateway: 10.1.1.1 => 10.1.2.xxx (the 2 can be any number except 1)

# Note: if you don't have any special config in your router, you can leave the default value.
VIRTUAL_MACHINE_IP = '192.168.2.100'

# The memory RAM of your virtual machine
VIRTUAL_MACHINE_MEMORY = '2048'

GIT_CONFIG_FILE = '~/.gitconfig'
GIT_IGNORE_FILE = '~/.gitignore'
SSH_PATH = '~/.ssh'
```
Edit whatever you want and save.
