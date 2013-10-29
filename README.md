Dedalus
=======
Vagrant and Docker files to build the infrastructure of the digital Siku quanshu project.

Get started
-----------
You need to install [Vagrant](http://www.vagrantup.com/) for your platform. To build and start
the virtual machine run
```Shell
vagrant up
```
in this directory (directory with the Vagrantfile).

What happens
------------
* An Ubuntu raring server cloud image will be downloaded (300 MB)
* [Docker](http://www.docker.io/) will be installed
* A docker base image [0xffea/raring...](https://index.docker.io/u/0xffea/raring-server-cloudimg-amd64/) (160 MB) will be downloaded
* [Django](https://www.djangoproject.com/) container will be build and started
* [Postgres](http://www.postgresql.org/) container will be build and started
