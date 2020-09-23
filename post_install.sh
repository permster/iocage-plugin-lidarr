#!/bin/sh

# set the version to install
# go to --> https://github.com/lidarr/Lidarr/releases
# to find the latest release, Lidar.develop.x.x.x.xxx.linux.tar.gz
VERSION="0.5.0.583"
# set the data location
DATA_LOCATION="/app-data/lidarr"

# make sure "mono" points to the proper location
ln -s /usr/local/bin/mono /usr/bin/mono

# get the "lidarr" package
fetch https://github.com/lidarr/Lidarr/releases/download/v$VERSION/Lidarr.develop.$VERSION.linux.tar.gz -o /usr/local/share

# unpack the package to the install location
tar -xzvf /usr/local/share/Lidarr.develop.*.linux.tar.gz -C /usr/local/share

# remove the package as it no longer needed
rm /usr/local/share/Lidarr.*.tar.gz

# create "lidarr" user
pw user add lidarr -c lidarr -u 353 -d /nonexistent -s /usr/bin/nologin

# create the data location
mkdir -p $DATA_LOCATION

# make "lidarr" the owner of the install and data locations
chown -R lidarr:lidarr /usr/local/share $DATA_LOCATION

# give write permission for plugin update
chmod 755 $DATA_LOCATION

# give execute permssion to the Daemon script
chmod u+x /usr/local/etc/rc.d/lidarr

# enable lidarr to start at boot
sysrc "lidarr_enable=YES"

# set the location for the data directory
sysrc "lidarr_data_dir=$DATA_LOCATION"

# start the lidarr service
service lidarr start
