FROM ubuntu:trusty

MAINTAINER Philipp Henkel <weltraumpilot@googlemail.com>

# Versions
ENV OSMOSIS_VERSION 0.44.1
ENV MAPSFORGE_VERSION 0.5.2
ENV PHYGHTMAP_VERSION 1.74

# Install a basic SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Standard SSH port
EXPOSE 22

# Install JDK 7 (latest edition)
RUN apt-get update && apt-get install -y openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --quiet jenkins

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Install git
RUN apt-get update && apt-get -y install git

# Install Osmosis
RUN wget http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-$OSMOSIS_VERSION.tgz
RUN mkdir osmosis
RUN tar xvfz osmosis-$OSMOSIS_VERSION.tgz --directory=osmosis
RUN rm osmosis-$OSMOSIS_VERSION.tgz
RUN chmod a+x osmosis/bin/osmosis
ENV PATH /osmosis/bin:$PATH
RUN echo 'export PATH=$PATH:/osmosis/bin' > /etc/profile.d/osmosis.sh
RUN chmod 775 /etc/profile.d/osmosis.sh

# Install Osmosis Mapsforge Map Writer
RUN wget http://ci.mapsforge.org/job/$MAPSFORGE_VERSION/lastSuccessfulBuild/artifact/mapsforge-map-writer/build/libs/mapsforge-map-writer-release-$MAPSFORGE_VERSION.jar
RUN mv mapsforge-map-writer-release-$MAPSFORGE_VERSION.jar osmosis/lib/default/

# Install Python
RUN apt-get update && apt-get -y install python2.7 python-pip
RUN pip install sh && \
    pip install logging && \
    pip install setuptools

# Install phyghtmap
RUN apt-get update && apt-get -y install python-matplotlib python-beautifulsoup python-numpy python-gdal
RUN wget http://katze.tfiu.de/projects/phyghtmap/phyghtmap_$PHYGHTMAP_VERSION.orig.tar.gz
RUN tar -xzf phyghtmap_$PHYGHTMAP_VERSION.orig.tar.gz
RUN cd phyghtmap-$PHYGHTMAP_VERSION && python setup.py install
RUN rm phyghtmap_$PHYGHTMAP_VERSION.orig.tar.gz
RUN rm -rf phyghtmap-$PHYGHTMAP_VERSION

# Clean out the apt-cache and cleaning out tmp
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/sbin/sshd", "-D"]
