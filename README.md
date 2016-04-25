# Synereo Dockerfiles

Dockerfiles for easily setting up a Synereo node.

## Prerequisites
  - git client installed and git command in path
  - docker installed (https://www.docker.com/) and running (start Docker Quick Terminal. Make a note of the default IP address assigned when starting up Docker and for example, default IP address may be 192.168.99.100). Using  [Kitematic](https://docs.docker.com/kitematic/) is very helpful. On Linuxes with modern kernels, such as Arch Linux, you can just use plain [Docker](https://wiki.archlinux.org/index.php/Docker)
  - mongodb running version: 2.6.4 (https://www.mongodb.com/) but it worked with the latest version
  - rabbitmq running version: 3.0.2 erlang version : 5.9.1 (15B03) (http://www.rabbitmq.com/) but works with the latest version by editing rabbitmq.config file (add this entry [{rabbit, [{loopback_users, []}]}] )

## Source files
Download files in a directory of your choice to build Docker image and make sure docker is running and available: 

    1. git clone https://github.com/n10n/DockerNode.git SpliciousBKND

## Build docker image using: 
Run the following command 

    2a. cd SpliciousBKND
    2b. docker build -t spliciousbkendimage . 

  Use "spliciousbkendimage" as image name in subsequent steps where image id is required. You can use any image name but it must be all lowercase. If step 2b failed for some reason, try to run (docker build .) and make a note of the Image ID and follow either manual or automated process step 3a
 
## Run docker image - manual process: 

    3a. docker run -i -t -e MONGODB_HOST=IP_ADDRESS -e MONGODB_PORT=27017 --name SpliciousBKEND -p 8888:9876 [ImageIDFromBuildStep_2b] /bin/bash
  
At the # command prompt
    
    3b. cd /usr/local/splicious
    3c. ./splicious.sh start
  
## Run docker image - automated process: 

    3a. docker run -i -t -e MONGODB_HOST=IP_ADDRESS -e MONGODB_PORT=27017 \
              --name SpliciousBKEND -p 8888:9876 [ImageIDFromBuildStep_2b] \
              /usr/local/splicious/run.sh
  
Please replace the IP_ADDRESS appropriately. To see log files, go to /usr/local/splicious/logs folder.

## Access container:

Visit the webpage http://<docker_quick_terminal_assigned_IP>:8888/agentui/agentui.html?demo=false and if this don't work then find the mapping URL (ipaddress:port from Kitematic screen - select your container there i.e. SpliciousBKEND). For example, you may see the map like 192.168.99.100:32772 then the URL would be http://192.168.99.100:32772/agentui/agentui.html?demo=false or http://192.168.99.100:8888/agentui/agentui.html?demo=false

See screenshot 
https://drive.google.com/open?id=0B1NrzDY6kx1JTzdPNVFlU19xekk

## Other notes:

Running with MongoDB as a linked node - follow the commands below (assuming mongo image is already installed) :

    docker run -it --name mdb1 -p 27017:27017 -d mongo
    docker run --name snode2 --link mdb1:mongo -e MONGODB_HOST=<Replace_192.168.99.100> -e MONGODB_PORT=27017  -p 8888:9876 -it spliciousbkendimage /bin/bash

To access UI from outside of the docker host, you would need to map the dockerhost ip/port to docker guest ip/port in Virtual Box (Network -> Port Forwarding) by adding rules.

To save a container to be used as an image

    docker commit [container_id] [name_in_lowercase]

To save an image to use in different docker installation

    docker save [name_in_lowercase] > [directory_location_to_save]/[image_name].tar

To load an image created in different docker installation 

    docker load < [image_name].tar

Running with the latest RabbitMQ version - edit rabbitmq.config file by adding [{rabbit, [{loopback_users, []}]}] to provide "guest" user access. This file mostly will be non existent and read more about access control [here](https://www.rabbitmq.com/access-control.html)
