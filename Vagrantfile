#
# Root Vagrant file
#

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "saucy-server"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/saucy/current/saucy-server-cloudimg-amd64-vagrant-disk1.box"

  # web server
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # postgresql server
  config.vm.network :forwarded_port, guest: 5432, host: 5432

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # setup base system
  config.vm.provision "shell",
    path: "scripts/provision-setup.sh"

  # install docker
  config.vm.provision "shell",
    path: "scripts/provision-docker.sh"

  # build postgres container
  config.vm.provision "shell",
    path: "scripts/provision-postgres.sh"

  # build django container
  config.vm.provision "shell",
    path: "scripts/provision-django.sh"

  # build exist-db container
  config.vm.provision "shell",
    path: "scripts/provision-existdb.sh"
end
