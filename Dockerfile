FROM lnlsdig/aravisgige-epics-module:debian-9.2

ENV IOC_REPO basler-acA1300-75gm-epics-ioc
ENV BOOT_DIR iocBasleracA130075gm
ENV COMMIT 0.1.0

RUN git clone https://github.com/lnls-dig/${IOC_REPO}.git /opt/epics/${IOC_REPO} && \
    cd /opt/epics/${IOC_REPO} && \
    git checkout ${COMMIT} && \
    echo '-include $(ARAVISGIGE)/configure/RELEASE.local' > configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'CALC=$(SUPPORT)/calc-3-4-2-1' >> configure/RELEASE.local && \
    echo 'BUSY=$(SUPPORT)/busy-1-6-1' >> configure/RELEASE.local && \
    echo 'SSCAN=$(SUPPORT)/sscan-2-10-1' >> configure/RELEASE.local && \
    echo 'AUTOSAVE=$(SUPPORT)/autosave-5-6-1' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'HDF5_LIB     = /usr/lib/x86_64-linux-gnu/hdf5/serial' >> configure/RELEASE.local && \
    echo 'HDF5_INCLUDE = -I/usr/include/hdf5/serial' >> configure/RELEASE.local && \
    echo >> configure/RELEASE.local && \
    echo 'SZIP_LIB       = /usr/lib' >> configure/RELEASE.local && \
    echo 'SZIP_INCLUDE   =' >> configure/RELEASE.local && \
    make && \
    make install && \
    make clean

# Source environment variables until we figure it out
# where to put system-wide env-vars on docker-debian
RUN . /root/.bashrc

WORKDIR /opt/epics/startup/ioc/${IOC_REPO}/iocBoot/${BOOT_DIR}

ENTRYPOINT ["./runProcServ.sh"]
