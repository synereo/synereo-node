# Synereo Dockerfiles

Dockerfiles for easily setting up a Synereo node.

## Prerequisites
  - git client installed and git command in path
  - docker installed (https://www.docker.com/) and running (start Docker Quick Terminal. Make a note of the default IP address assigned when starting up Docker and for example, default IP address may be 192.168.99.100). Using  [Kitematic](https://docs.docker.com/kitematic/) is very helpful. On Linuxes with modern kernels, such as Arch Linux, you can just use plain [Docker](https://wiki.archlinux.org/index.php/Docker)
  - mongodb running version: 2.6.4 (https://www.mongodb.com/) but it worked with the latest version
  - rabbitmq running version: 3.0.2 erlang version : 5.9.1 (15B03) (http://www.rabbitmq.com/) but works with the latest version by editing rabbitmq.config file (add this entry [{rabbit, [{loopback_users, []}]}] )

## Source files
Download files in a directory of your choice or use command as below to build Docker image (make sure docker is running and available). Windows users, run "git config --global core.autocrlf false" command before running the git clone command otherwise container may fail to execute properly.

    1. git clone https://github.com/synereo/dockernode.git SpliciousBKND

## Build docker image using: 
Run the following command 

    2a. cd SpliciousBKND
    2b. docker build -t spliciousbkendimage . 

  Use "spliciousbkendimage" as image name in subsequent steps where image id is required. You can use image name of your choice but it must be all lowercase. 
 
## Running docker image - manual process: 

    3a. docker run -it -e MONGODB_HOST=IP_ADDRESS -e MONGODB_PORT=27017 --name SpliciousBKEND -p 8888:9876 spliciousbkendimage /bin/bash
  
At the # command prompt
    
    3b. cd /usr/local/splicious
    3c. ./run.sh start
  
## Running docker image - automated process: 

    3a. docker run -it -e MONGODB_HOST=IP_ADDRESS -e MONGODB_PORT=27017 \
              --name SpliciousBKEND -p 8888:9876 spliciousbkendimage \
              /usr/local/splicious/run.sh
  
Please replace the IP_ADDRESS appropriately. To see log files, go to /usr/local/splicious/logs folder.

## Access container:

Visit the webpage http://<docker_quick_terminal_assigned_IP>:8888/agentui/agentui.html?demo=false and if this don't work then find the mapping URL (ipaddress:port from Kitematic screen - select your container there i.e. SpliciousBKEND). For example, you may see the access URL like 192.168.99.100:8888 then access backend using http://192.168.99.100:8888/agentui/agentui.html?demo=false

The default user name/password is admin@localhost/a and can be changed in /usr/local/splicious/eval.conf file

See screenshot 
https://drive.google.com/open?id=0B1NrzDY6kx1JTzdPNVFlU19xekk

## Other notes:

Running with MongoDB as a linked node - follow the commands below (assuming mongo image is already installed) :

    docker run -it --name mdb1 -p 27017:27017 -d mongo
    docker run --name snode2 --link mdb1:mongo -e MONGODB_HOST=192.168.99.100 -e MONGODB_PORT=27017  -p 8888:9876 -it spliciousbkendimage /bin/bash

On docker contain prompt # run the following commands

    cd /usr/local/splicious
    ./run.sh start

To access UI from outside of the docker host, you would need to map the dockerhost ip/port to docker guest ip/port in Virtual Box (Network -> Port Forwarding) by adding rules.

To save a container to be used as an image

    docker commit [container_id] [name_in_lowercase]

To save an image to use in different docker installation

    docker save [name_in_lowercase] > [directory_location_to_save]/[image_name].tar

To load an image created in different docker installation 

    docker load < [image_name].tar

Running with the latest RabbitMQ version - edit rabbitmq.config file by adding [{rabbit, [{loopback_users, []}]}] to provide "guest" user access. This file mostly will be non existent and read more about access control [here](https://www.rabbitmq.com/access-control.html)
