FROM lnlsdig/aravisgige-epics-module:R2-1-LNLS2-base-3.15-debian-9

ARG IOC_GROUP
ARG IOC_REPO

ENV BOOT_DIR iocBasleracA130075gm

ENV NDPLUGIN_DIMFEI_COMMIT v0.2.0

ENV FFMPEG_COMMIT 0f8341cb27ed97551b7cdbdd996a8b831251afaf

ARG APT_PROXY_SERVER=TA-TiRack-CO-FWSrv-1.abtlus.org.br:3142
RUN echo \
        "Acquire::http { Proxy \"http://${APT_PROXY_SERVER}\"; }" > /etc/apt/apt.conf.d/proxy ;\
    apt-get update && \
    apt-get install -y socat

# Install ffmpeg and build ffmpegServer
RUN apt-get update && \
    apt-get install -y unzip

RUN git clone https://github.com/areaDetector/ffmpegServer.git /opt/epics/ffmpegServer && \
    cd /opt/epics/ffmpegServer && \
    git checkout ${FFMPEG_COMMIT} && \
    ./install.sh && \
    echo 'ARAVISGIGE=/opt/epics/aravisGigE' > configure/RELEASE.local && \
    echo '-include $(ARAVISGIGE)/configure/RELEASE.local' >> configure/RELEASE.local && \
    make

# Install NDPluginDimFei
RUN sudo apt-get update && \
    sudo apt-get install -y \
        liblapack3 \
        liblapack-dev \
        libopenblas-base \
        libopenblas-dev \
        liblapacke-dev

RUN git clone https://github.com/lnls-dig/NDPluginDimFei.git /opt/epics/NDPluginDimFei && \
    cd /opt/epics/NDPluginDimFei && \
    git checkout ${NDPLUGIN_DIMFEI_COMMIT} && \
    sed -i -e 's|^DIRS += install.*$|#DIRS += install|' Makefile && \    
    echo 'SUPPORT=/opt/epics/synApps-lnls-R0-0-2/support' > configure/RELEASE.local && \
    echo '-include $(SUPPORT)/configure/RELEASE' >> configure/RELEASE.local && \
    make && \
    make install

# Install basler-acA1300-75gm epics ioc
RUN git clone https://github.com/${IOC_REPO}/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT} && \
    echo 'ARAVISGIGE=/opt/epics/aravisGigE' > configure/RELEASE.local && \
    echo '-include $(ARAVISGIGE)/configure/RELEASE.local' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'FFMPEGSERVER=/opt/epics/ffmpegServer' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'DIMFEI=/opt/epics/NDPluginDimFei' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'CALC=$(SUPPORT)/calc-R3-7' >> configure/RELEASE.local && \
    echo 'BUSY=$(SUPPORT)/busy-R1-7' >> configure/RELEASE.local && \
    echo 'SSCAN=$(SUPPORT)/sscan-R2-11-1' >> configure/RELEASE.local && \
    echo 'AUTOSAVE=$(SUPPORT)/autosave-R5-9' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'HDF5_LIB     = /usr/lib/x86_64-linux-gnu/hdf5/serial' >> configure/RELEASE.local && \
    echo 'HDF5_INCLUDE = -I/usr/include/hdf5/serial' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'SZIP_LIB       = /usr/lib' >> configure/RELEASE.local && \
    echo 'SZIP_INCLUDE   =' >> configure/RELEASE.local && \
    make && \
    make install

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
