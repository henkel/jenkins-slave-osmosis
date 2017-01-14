Docker container with the toolchain to create [mapsforge maps](https://github.com/mapsforge/mapsforge/blob/master/docs/Specification-Binary-Map-File.md) with osmosis, mapsforge-map-writer plugin and phyghtmap. The container can be used stand-alone or as a SSH based Jenkins slave. 


# Osmosis
Osmosis is a command line Java application for processing OSM data. The tool consists of pluggable components that can be chained to perform a larger operation. For example, it has components for reading/writing databases and files, deriving/applying changes to data sources, and sorting data.

> [wiki.openstreetmap.org](http://wiki.openstreetmap.org/wiki/Osmosis)


# How to use this image stand-alone

The following docker command runs the image, maps the user's home directory into /opt/osmosis and opens an interactive shell. 
```console
$ docker run --rm  -i -t -v ~:/opt/osmosis henkel/jenkins-slave-osmosis:latest bash
```

Now osmosis is ready to process OpenStreetMap data in directory /opt/osmosis.
```console
$ osmosis --rbf /opt/osmosis/germany-latest.osm.pbf --tee 1 --bounding-box left=8.30 bottom=48.86 right=8.59 top=49.03 --wx /opt/osmosis/karlsruhe.osm
```


# How to use this image with Jenkins
Jenkins is able to automatically pull the image and launch the build slave using its Cloud feature.

Add a new Docker Template to Jenkins' Docker Cloud:
1. Docker Image: henkel/jenkins-slave-osmosis:latest
2. Volumes: <your local path>:/opt/osmosis
3. Labels: osmosis
4. Usage: Only build jobs with label restrictions matching this node
5. Launch Method: Docker SSH computer launcher
6. Credentials: jenkins/jenkins

Jenkins executes build scripts via a non-interactive SSH shell. You might want to load the environment explicitly at the beginning of your script so that the path to osmosis is properly configured.

```console
#!/bin/bash
. /etc/profile
```

# License

Copyright (C) 2015-2017 Philipp Henkel

Licensed under the MIT License (MIT). See LICENSE file for more details.
