# Synereo Dockerfiles

Dockerfiles for easily setting up a Synereo node.

## Prerequisites

Install and be familiar with [Docker](https://docs.docker.com/userguide/). On OS X or Windows you'll probably want to use [Kitematic](https://docs.docker.com/kitematic/). On Linuxes with modern kernels, such as Arch Linux, you can just use plain [Docker](https://wiki.archlinux.org/index.php/Docker).

## Architecture

### Dependencies

Synereo nodes have two official Docker images as dependencies: [RabbitMQ](https://registry.hub.docker.com/_/rabbitmq/) and [MongoDB](https://registry.hub.docker.com/_/mongo/).

### Synereo Image

The Synereo image is built from [synereo/Dockerfile](synereo/Dockerfile). For full flexibility, instead of building on existing images we install all the dependencies ourselves, but we rely on much of the good code from these repos:

 - https://registry.hub.docker.com/_/java/
 - https://registry.hub.docker.com/u/williamyeh/scala/
 - https://registry.hub.docker.com/u/williamyeh/sbt/

## Usage

Start off by building the image:

```bash
$ cd synereo
$ docker build -t synereo/synereo:v0 .
```

Once the image is created you can run stuff in it, e.g. to get a bash prompt and check the versions, run:

```bash
$ docker run -it synereo/synereo:v0 /bin/bash
root@1122aabb3344ccdd# java -version
root@1122aabb3344ccdd# scala -version
root@1122aabb3344ccdd# sbt -version
```
