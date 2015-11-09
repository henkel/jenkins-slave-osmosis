Docker image with osmosis, mapsforge-map-writer plugin and phyghtmap. The image can be used stand-alone or as a SSH based Jenkins slave. 

# Osmosis
Osmosis is a command line Java application for processing OSM data. The tool consists of pluggable components that can be chained to perform a larger operation. For example, it has components for reading/writing databases and files, deriving/applying changes to data sources, and sorting data.

> [wiki.openstreetmap.org](http://wiki.openstreetmap.org/wiki/Osmosis)

# How to use this image stand-alone

The following docker command runs the image, maps the user's home directory into /opt/osmosis and opens an interactive shell. 
```console
$ docker run --rm  -i -t -v ~:/opt/osmosis henkel/jenkins-slave-osmosis:latest bash
```

Now osmosis is ready to process OpenStreetMap data in /opt/osmosis.
```console
$ osmosis --rbf /opt/osmosis/germany-latest.osm.pbf --tee 1 --bounding-box left=8.30 bottom=48.86 right=8.59 top=49.03 --wx /opt/osmosis/karlsruhe.osm
```

# How to use this image with Jenkins
TODO
