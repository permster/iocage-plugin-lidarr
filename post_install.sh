#!/bin/sh

# get the "lidarr" package
fetch $(curl -s https://api.github.com/repos/lidarr/Lidarr/releases | grep browser_download_url | grep 'linux[.]tar.gz' | head -n 1 | cut -d '"' -f 4) -o /usr/local/share

# unpack the package to the install location
tar -xzvf /usr/local/share/Lidarr.*.linux.tar.gz -C /usr/local/share

# remove the package as it no longer needed
rm /usr/local/share/Lidarr.*.linux.tar.gz

# create "lidarr" user
pw user add lidarr -c lidarr -u 353 -d /nonexistent -s /usr/bin/nologin

# make "lidarr" the owner of the install and data locations
mkdir /config
chown -R lidarr:lidarr /usr/local/share/Lidarr /config

# give write permission for plugin update
chmod 755 /usr/local/share/Lidarr

# Start the services
chmod u+x /etc/rc.d/lidarr
sysrc -f /etc/rc.conf lidarr_enable="YES"
service lidarr start

echo "Lidarr successfully installed" > /root/PLUGIN_INFO