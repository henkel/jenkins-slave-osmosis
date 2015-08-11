FROM evarga/jenkins-slave

MAINTAINER Philipp Henkel <weltraumpilot@googlemail.com>

RUN apt-get update

# Osmosis
RUN wget http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-latest.tgz 
RUN mkdir osmosis
RUN tar xvfz osmosis-latest.tgz --directory=osmosis
RUN rm osmosis-latest.tgz
RUN chmod a+x osmosis/bin/osmosis

# Osmosis Mapsforge Map Writer
RUN wget http://download.mapsforge.org/releases/0.5.1/mapsforge-map-writer/build/libs/mapsforge-map-writer-0.5.1.jar
RUN mv mapsforge-map-writer-0.5.1.jar osmosis/lib/default/

# Python
RUN apt-get -y install python2.7 python-pip
RUN pip install sh && \
    pip install logging && \
    pip install setuptools

# Install phyghtmap
RUN apt-get -y install python-matplotlib python-beautifulsoup python-numpy python-gdal
RUN wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_1.73.orig.tar.gz
RUN tar -xzf phyghtmap_1.73.orig.tar.gz
RUN cd phyghtmap-1.73 && python setup.py install
RUN rm phyghtmap_1.73.orig.tar.gz
RUN rm -rf phyghtmap-1.73