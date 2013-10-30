#
#
#

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "raring-server"
  config.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  config.vm.provider :virtualbox do |vb|
    vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  # fix locale
  config.vm.provision "shell",
    inline: "apt-get -y install language-pack-en"

  # install docker
  config.vm.provision "shell",
    path: "scripts/provision-docker.sh"

  # build postgres container
  config.vm.provision "shell",
    path: "scripts/provision-postgres.sh"

  # build django container
  config.vm.provision "shell",
    path: "scripts/provision-django.sh"
end
