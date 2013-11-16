Dedalus
=======
Vagrant and Docker files to build the infrastructure of the digital Siku quanshu project.

Get started
-----------
You need to install [Vagrant](http://www.vagrantup.com/) for your platform. On Ubuntu
just run
```shell
apt-get install vagrant
```

To build and start the virtual machine run
```Shell
vagrant up
```
in this directory (directory with the Vagrantfile).

Now you can reach the website at port 8000. The eXist dashboard can be found on port 8080.
```shell
kde-open http://localhost:8000
```

What happens
------------
* An Ubuntu 13.10 (Saucy) image will be downloaded (300 MB)
* [Docker](http://www.docker.io/) will be installed
* A docker base image [0xffea/saucy...](https://index.docker.io/u/0xffea/saucy-server-cloudimg-amd64/) (90 MB) will be downloaded
* [Django](https://www.djangoproject.com/) container will be build and started. Public port 80
* [Postgres](http://www.postgresql.org/) container will be build and started. Public port 5432
* [eXistdb](http://exist-db.org/) container will be downloaded and started. Public port 8080

Tested on
---------
* Windows 7
* Ubuntu 13.10
