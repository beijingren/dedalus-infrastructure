Dedalus
=======
Vagrant and Docker files to build the infrastructure of the digital Siku quanshu project.

Get started
-----------
You need to install [Vagrant](http://www.vagrantup.com/) (>= 1.2) for your platform. On Ubuntu
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
* An Ubuntu 14.04 image will be downloaded
* [Django](https://www.djangoproject.com/) container will be build and started. Public port 80
* [Postgres](http://www.postgresql.org/) container will be build and started. Public port 5432
* An eXist-db base image [](https://index.docker.io/u/0xffea/saucy-server-existdb-amd64/) (440 MB) will be downloaded
* [eXistdb](http://exist-db.org/) container will be build and started. Public port 8080
* [Fuseki](http://jena.apache.org/) container will be build and started. Public port 3030

Tested under
------------
* Windows 7
* Ubuntu 14.04

Stay hungry. Stay foolish.
--------------------------
```shell
vagrant suspend
# After days
vagrant resume
vagrant provision
```
