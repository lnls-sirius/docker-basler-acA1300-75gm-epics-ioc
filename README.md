Docker image to run the Basler acA1300-75gm camera EPICS IOC 
==================================================================

This repository contains the Dockerfile used to create the Docker image to run the
[EPICS IOC for the Basler acA1300-75gm camera](https://github.com/lnls-dig/basler-acA1300-75gm-epics-ioc).

## Running the IOC

The simples way to run the IOC is to run:

    docker run --rm -it --net host lnlsdig/basler-aca1300-75gm-epics-ioc -s SERIAL_NUMBER

where `SERIAL_NUMBER` is the serial number of the camera to connect to. The options you
can specify (after `lnlsdig/basler-aca1300-75gm-epics-ioc`):

- `-s SERIAL_NUMBER`: camera serial number, which is used to connect the to camera (required)
- `-P PREFIX1`: the value of the EPICS `$(P)` macro used to prefix the PV names
- `-R PREFIX2`: the value of the EPICS `$(R)` macro used to prefix the PV names
- `-t TELNET_PORT`: telnet port to use for connecting to procServ (defaults to 20000)
- `-A HL_PREFIX`: the prefix to use for the high level PVs defined in the IOC
- `-H HTTP_PORT`: the HTTP server port to use for ffmpeg server (default 8080)
- `-n FFMPEG_PORT`: the ffmpeg server port name to use. This will be displayed on the server index page

## Creating a Persistent Container

If you want to create a persistent container to run the IOC, you can run a
command similar to:

    docker run -it --net host --restart always --name CONTAINER_NAME lnlsdig/basler-aca1300-75gm-epics-ioc -s SERIAL_NUMBER

where `SERIAL_NUMBER` is as in the previous section and `CONTAINER_NAME` is the name
given to the container. You can also use the same options as described in the
previous section.

## Building the Image Manually

To build the image locally without downloading it from Docker Hub, clone the
repository and run the `docker build` command:

    git clone https://github.com/lnls-dig/docker-basler-acA1300-75gm-epics-ioc
    docker build -t lnlsdig/basler-aca1300-75gm-epics-ioc docker-basler-acA1300-75gm-epics-ioc
