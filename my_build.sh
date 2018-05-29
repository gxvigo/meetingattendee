#!/bin/sh

# clean current running containers (all of them)
docker kill $(docker ps -q)
docker rm $(docker ps -a -q)

# start a mongo db container
docker run --name=mongo -e MONGO_HOST='docker.for.mac.host.internal' -v /Users/giovanni/opt/workspaces/NodeSamples/nodetest1/data/db:/data/db -p 27017:27017 -d mongo:3.6.5

# get current application version
source buildversion.cfg
echo 'Current vesion' $version

# increase version number
NEWVERSION=$(($version + 1))
echo 'New vesion' $NEWVERSION

# set image tag
IMAGETAG='gxvigo/attendees:'$version'.0' 

# build docker image and run container
docker build -t $IMAGETAG . 
docker run -p 13000:3000 --link mongo -d $IMAGETAG 

# persiste new version on file
echo version=$NEWVERSION > buildversion.cfg



# list running containers
docker ps;



