# Synereo Dockerfiles

Dockerfiles for easily setting up a Synereo node.

## Prerequisites

Install and be familiar with [Docker](https://docs.docker.com/userguide/). On OS X or Windows you'll probably want to use [Kitematic](https://docs.docker.com/kitematic/). On Linuxes with modern kernels, such as Arch Linux, you can just use plain [Docker](https://wiki.archlinux.org/index.php/Docker).

## Architecture

Synereo nodes have two main official Docker images as dependencies: [RabbitMQ](https://registry.hub.docker.com/_/rabbitmq/) and [MongoDB](https://registry.hub.docker.com/_/mongo/). The rest of the Synereo stack that ties it all together is provided via the `synereo` image in this repo.
