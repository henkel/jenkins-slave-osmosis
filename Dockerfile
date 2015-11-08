FROM evarga/jenkins-slave

MAINTAINER Philipp Henkel <weltraumpilot@googlemail.com>

# Make sure the package repository is up to date.
RUN apt-get update

# Install git
RUN apt-get -y install git

# Install Osmosis
RUN wget http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-0.44.1.tgz
RUN mkdir osmosis
RUN tar xvfz osmosis-0.44.1.tgz --directory=osmosis
RUN rm osmosis-0.44.1.tgz
RUN chmod a+x osmosis/bin/osmosis
ENV PATH /osmosis/bin:$PATH
RUN echo 'export PATH=$PATH:/osmosis/bin' > /etc/profile.d/osmosis.sh
RUN chmod 775 /etc/profile.d/osmosis.sh

# Install Osmosis Mapsforge Map Writer
RUN wget http://ci.mapsforge.org/job/0.5.2/lastSuccessfulBuild/artifact/mapsforge-map-writer/build/libs/mapsforge-map-writer-release-0.5.2.jar
RUN mv mapsforge-map-writer-release-0.5.2.jar osmosis/lib/default/

# Install Python
RUN apt-get -y install python2.7 python-pip
RUN pip install sh && \
    pip install logging && \
    pip install setuptools

# Install phyghtmap
RUN apt-get -y install python-matplotlib python-beautifulsoup python-numpy python-gdal
RUN wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_1.74.orig.tar.gz
RUN tar -xzf phyghtmap_1.74.orig.tar.gz
RUN cd phyghtmap-1.74 && python setup.py install
RUN rm phyghtmap_1.74.orig.tar.gz
RUN rm -rf phyghtmap-1.74