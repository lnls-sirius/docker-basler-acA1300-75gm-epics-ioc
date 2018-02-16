FROM lnls/epics-dist

RUN apt-get update && \
    apt-get install -y \
        intltool \
        libgirepository1.0-dev \
        gtk-doc-tools \
        libglib2.0-dev

RUN git clone https://github.com/lnls-dig/aravis.git /opt/aravis && \
    cd /opt/aravis && \
    git checkout bd182447a5dbc2041a9572a347de12ed95ce15e5 && \
    ./autogen.sh && \
    make distclean

RUN git clone https://github.com/areaDetector/aravisGigE /opt/epics/aravisGigE && \
    cd /opt/epics/aravisGigE && \
    git checkout R2-1 && \
    echo 'EPICS_BASE=/opt/epics/base' > configure/RELEASE.local && \
    echo 'SUPPORT=/opt/epics/synApps_5_8/support' >> configure/RELEASE.local && \
    echo 'AREADETECTOR=$(SUPPORT)/areaDetector-R2-0' >> configure/RELEASE.local && \
    echo 'ADCORE=$(AREADETECTOR)/ADCore-R2-2' >> configure/RELEASE.local && \
    echo 'ASYN=$(SUPPORT)/asyn-4-26' >> configure/RELEASE.local && \
    echo 'GLIBPREFIX=/usr' >> configure/RELEASE.local && \
    echo 'GLIB_INC1=/usr/lib/x86_64-linux-gnu/glib-2.0/include' >> configure/RELEASE.local && \
    echo 'GLIB_INC2=/usr/lib/x86_64-linux-gnu/glib-2.0/include' >> configure/RELEASE.local && \
    sed -i -e 's/^USR_LIBS += glib-2.0$/USR_SYS_LIBS += glib-2.0/' aravisGigEApp/src/Makefile && \
    ln -s /opt/aravis vendor && \
    make
