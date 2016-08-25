
## Synereo Node Dockerfile

Help to set up a standalone node. These instructions are valid for first time use only and once docker image is created and working then use `docker start sn1` command in sebsequent run. 

This docker image contains both older and newer version of UIs (i.e. older, Splicious and newer, Synereo).

## Time needed

This process may take around 10-30 minutes to download around 750 MB of data. 

## Prerequisites
 * Minimum 4GB RAM but 6 GB RAM is recommended. (Don't work properly with Windows 7 home version)
 * Docker installed (https://www.docker.com/) and running Docker process(es). Basic knowledge of Docker and executing various Docker commands. 
 
## Steps

### Getting source files
Download docker [configuration file](https://raw.githubusercontent.com/synereo/dockernode/single/Dockerfile) in a directory of your choice (we called the directory "snodedir") and name it "Dockerfile" (Docker required to name the file). Or run the following commands on the prompt you get after running the Docker terminal:

    1. cd snodedir (if do not exist then create one using `mkdir snodedir`)
    2. curl -sL https://raw.githubusercontent.com/synereo/dockernode/single/Dockerfile -o Dockerfile

### Build docker image using 
Use "snode" as a docker image name and use same name in subsequent steps where docker image id is required. You also can use image name of your choice but it must be all lowercase.

    3. docker build -t snode . (this step requires that a `Dockerfile` file  must exist, you downloaded in above step)

### Running standalone node:
To run the docker image, use docker command below: 

    4. docker run -it -p 80:9000 -p 8080:9876 -h mynodehost --dns 8.8.8.8 --name sn1 -d snode 
  
## Accessing container:

Visit the URL `http://<docker_IP>:80/` and if you don't know the docker_IP address then you can find the mapping URL in Kitematic screen (You may need to install "Kitematic" from docker.com. Select your container there i.e. snode and see for ip/port mapping). For example, to access new UI, use URL http://192.168.99.100:80/ if using Windows and older version of Docker on Mac (pre native older docker i.e. less than 1.12). With newer version of Docker (still in beta i.e. 1.12.x) on Mac then use http://127.0.0.1:80/ . For Linux, the URL may be http://172.17.0.1/. When asked for "API Detail", please fill `<docker_IP>:8080`. (For 8080, see above the port mapping). 

After API detail, you need to provide username and password. The default user name/password combination is admin@localhost/a. The deafults can be changed in /usr/local/splicious/eval.conf file by editing `nodeAdminEmail` and `nodeAdminPass` and to edit it, you would need to login into the Docker container to change it.
