
## Backend Dockerfile

Dockerfile for easily setting up a node and instructions are for building backend from the source code (This takes sometime to build i.e. around 20-40 minutes). These instructions are valid for first time use and once docker images are created and working then use `docker start ...` command. This build image contains older version of UI (i.e. Splicious UI) and newer version of Synnero UI is not yet ready for distritbution.

## Prerequisites
 * Minimum 2GB RAM but 4 GB RAM is recommended for compling the source code.
 * Basic knowledge of Docker. Docker installed (https://www.docker.com/) and running Docker process. Using  [Kitematic](https://docs.docker.com/kitematic/) to start the docker process is very helpful and advisable if using Windows or Mac. On modern linux kernel based system, such as Arch Linux, you can just use plain [Docker](https://wiki.archlinux.org/index.php/Docker). Make a note of assigned IP address when starting up Docker and for example, in Windows and Mac, assigned IP address is 192.168.99.100. If want to use existing Docker image to run backend (preferred method) then use the image from Docker hub using `docker pull livelygig/backend` after that jump to 'Running' section below and change the docker image to `livelygig/backend` from `spliciousbkendimage` in docker run command. 
  
  [https://hub.docker.com/r/livelygig/backend/](https://hub.docker.com/r/livelygig/backend/)
  
  MongoDB is required to run a standalone node. MongoDB and RabbitMQ are required to run a full node. 
  
 * git client installed and git command in path if want to build the node from scratch otherwise use Docker image (preferred method)
 * mongodb running version: 2.6.4 (https://www.mongodb.com/) but it worked with the latest version. Follow the instruction below if want to use Docker image. Importing old MongoDB database dump from different node is not advisable.

    `docker pull mongo` then 
    `docker run --name mdb1 -p 27017:27017 -d mongo`

 - rabbitmq running version: 3.0.2 erlang version : 5.9.1 (15B03) (http://www.rabbitmq.com/) but works with the latest version by editing rabbitmq.config file (add this entry [{rabbit, [{loopback\_users, []}]}] ). Follow the instruction below if want to run Docker image. (https://hub.docker.com/_/rabbitmq/) 

    `docker pull rabbitmq` then 
    `docker run --name rabbitmq1 -p 4369:4369 -p 5671:5671 -p 5672:5672 -p 25672:25672 -d rabbitmq`

## Source files
Download files in a directory of your choice or use command as below to build Docker image (make sure docker is running and available). Windows users, run "git config --global core.autocrlf false" command before running the git clone command otherwise container may fail to execute properly.

    1. git clone https://github.com/synereo/dockernode.git SpliciousBKND

## Build docker image using: 
Run the following commands

    2a. cd SpliciousBKND
    2b. docker build -t spliciousbkendimage . 

  Use "spliciousbkendimage" as image name in subsequent steps where image id is required. You can use image name of your choice but it must be all lowercase. 
 
## Running standalone node:
Standalone mode requires running MongoDB and please replace the IP_ADDRESS (this address is accquired by docker and displays at starting of it i.e. 192.168.99.100 in Windows and Mac) appropriately below.

#### Running docker image - manual process: 

    3a. docker run -it -e MONGODB_HOST=IP_ADDRESS -e MONGODB_PORT=27017 \
                   --name backendNode -p 8888:9876 spliciousbkendimage /bin/bash
  
At the # prompt, run the commands below
    
    3b. cd /usr/local/splicious
    3c. ./run.sh
  
#### Running docker image - automated process: 

    3a. docker run -it -e MONGODB_HOST=IP_ADDRESS -e MONGODB_PORT=27017 \
                   --name backendNode -p 8888:9876 -d spliciousbkendimage /usr/local/splicious/run.sh

## Running a full node:
A full  node requires both MongoDB and RabbitMQ. It is advisable to use standalone mode for first time and then switch to full node. Please replace the IP_ADDRESS appropriately for MongoDB (in case of docker image of MongoDB, this address is accquired by docker and displays at starting of it i.e. 192.168.99.100 in Windows and Mac or locate new container in Kitemate to find the IP address). Copy eval.conf file (https://github.com/synereo/gloseval/blob/1.0/eval.conf) into a Docker host folder and will map this folder later on. Update the following key/value pair in eval.conf file appropirately:

- Update with remote RabbitMQ node IP Address: `DSLCommLinkServerHost`, `DSLEvaluatorPreferredSupplierHost` and  `BFactoryCommLinkServerHost`

- Update with local RabbitMQ IP Address: `DSLCommLinkClientHost`, `DSLEvaluatorHost`, `DSLEvaluatorPreferredSupplierHost` and `BFactoryCommLinkClientHost`

After updating ip addresses, run the following command in a sequence: 

    - docker run -it --name mdb1 -p 27017:27017 -d 
    - docker run --name rabbitmq1 -p 4369:4369 -p 5671:5671 -p 5672:5672 -p 25672:25672 -d rabbitmq 
    - docker run -it --link mdb1:mongo --link rabbitmq1:rabbitmq -v <Mapped_Folder_WITH_EVAL.CONF>:/usr/local/splicious/config -e MONGODB_HOST=<IP_ADDRESS> -e MONGODB_PORT=27017 -e DEPLOYMENT_MODE=distributed -p 8888:9876 --name backendNode -d livelygig/backend /usr/local/splicious/run.sh
  
  For example:
  ```
  docker run -it --link mdb1:mongo \
                 --link rabbitmq1:rabbitmq \
                 -v /Users/n/tmp/dockerspliciousconfig>:/usr/local/splicious/config \
                 -e MONGODB_HOST=192.168.99.100 \
                 -e MONGODB_PORT=27017 \
                 -e DEPLOYMENT_MODE=distributed \
                 -p 8888:9876 --name backendNode \
                 -d livelygig/backend /usr/local/splicious/run.sh`
  ```
## Accessing container:

Visit the webpage `http://<docker_IP>:8888/agentui/agentui.html?demo=false` and if this doesn't work then find the mapping URL (ipaddress:port from Kitematic screen - select your container there i.e. backendNode). For example, you may see the access URL like 192.168.99.100:8888 then access the backend using http://192.168.99.100:8888/agentui/agentui.html?demo=false URL

The default user name/password is admin@localhost/a and can be changed in /usr/local/splicious/eval.conf file by editing `nodeAdminEmail` and `nodeAdminPass` or add NODEADMINEMAIL and NODEADMINPASS to docker run command. For example:
  ```
  docker run -it --link mdb1:mongo \
                 --link rabbitmq1:rabbitmq \
                 -v /Users/n/tmp/dockerspliciousconfig:/usr/local/splicious/config \
                 -e NODEADMINEMAIL=runforfun@localhost \
                 -e NODEADMINPASS=FunNeverEnds2016 \
                 -e MONGODB_HOST=192.168.99.100 \
                 -e MONGODB_PORT=27017 \
                 -e DEPLOYMENT_MODE=distributed \
                 -p 8888:9876 --name backendNode \
                 -d livelygig/backend /usr/local/splicious/run.sh
  ```
See screenshot 
https://drive.google.com/open?id=0B1NrzDY6kx1JTzdPNVFlU19xekk. To see log files, go to /usr/local/splicious/logs folder after login into the container.

## Other notes:

For some reason, the data gets corrupted in MongoDB then, starting a new container is the best way. Windows and Mac don't support mapping of external folder for data and config with MongoDB's Docker image. If using non Docker MongoDB, then the easiest way to reset database is by following the steps below:

    Stop backend node
    Stop MongoDB be process by running  (one way doing is by running - mongo 127.0.0.1/admin --eval "db.shutdownServer()")
    Rename "db directory" (defined in configuration file)
    Create "db directory"
    Start MongoDB process
    Start backend node

To access UI from outside of the docker host, you would need to map the docker host ip/port to docker guest ip/port in Virtual Box (Network -> Port Forwarding) by adding rules.

To save a container to be used as an image

    docker commit [container_id] [name_in_lowercase]

To save an image to use in different docker installation or publish into Docker Hub (https://hub.docker.com/). For that, please follow the instruction at https://docs.docker.com/docker-hub/repos/.

    docker save [name_in_lowercase] > [directory_location_to_save]/[image_name].tar

To load an image created in different docker installation 

    docker load < [image_name].tar

Running with the latest RabbitMQ version - edit rabbitmq.config file by adding [{rabbit, [{loopback\_users, []}]}] to provide 'guest' user access. This file mostly will be non existent and read more about RabbitMQ access control [here](https://www.rabbitmq.com/access-control.html) and Docker image has 'guest' access enabled by default.
