
## Synereo Node Dockerfile

Help to set up a standalone node. These instructions are valid for first time use only and once docker image is created and working then use `docker start ...` command in sebsequent run. 

This docker image contains both older and newer version of UIs (i.e. older, Splicious and newer, Synereo).

## Time needed

This process may take around 10-30 minutes to download around 750 MB of data. 

## Prerequisites
 * Minimum 2GB RAM but 4 GB RAM is recommended for compling the source code.
 * Basic knowledge of Docker. Docker installed (https://www.docker.com/) and running Docker process. 
 * Other necessary softwares needed to run the node are part of the Docker image (i.e. MongoDB, RabbitMQ and many more)

## Source files
Download docker [configuration file](https://raw.githubusercontent.com/synereo/dockernode/single/Dockerfile) in a directory of your choice (we called the directory "snodedir") and name it "Dockerfile"

## Build docker image using 
Run the following commands:

    1. cd snodedir

Use "snode" as a docker image name and use same name in subsequent steps where docker image id is required. You also can use image name of your choice but it must be all lowercase.

    2. docker build -t snode . 

  Use "snode" as a docker image name in subsequent steps where image id is required. You can use image name of your choice but it must be all lowercase. 
 
## Running standalone node:
To runn the docker image, use docker command below: 

    3. docker run -it -p 80:9000 -p 8080:9876 -h mynodehost --dns 8.8.8.8 --name sn1 -d snode 
  
## Accessing container:

Visit the webpage `http://<docker_IP>:80/` and if you don't know the docker_IP address then you find the mapping URL (ipaddress:port from Kitematic screen - select your container there i.e. snode). For example, the access new UI, use URL http://192.168.99.100:80/ if using Windows and older version of Docker on Mac (pre native docker). With newer version of Docker (still in beta) on Mac then use http://127.0.0.1:80/ . For Linux, the URL may be http://172.17.0.1/. When asked for "API Detail", please fill `<docker_IP>` address for hostname in first text box and 8080 for port number in second text box then click on "Submit".

The default user name/password is admin@localhost/a. The deafults can be changed in /usr/local/splicious/eval.conf file by editing `nodeAdminEmail` and `nodeAdminPass` and to edit it, you would need to login into the container.
