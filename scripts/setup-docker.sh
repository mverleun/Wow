#!/bin/bash

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

#    Author: Marco Verleun
#    See also: http://www.iot-kit.nl/
#

#    This script is ment to be run on a Raspberry Pi. It uses the sudo command
#    to elevate priviliges.

# Do a couple of things to make the script more robust

export LANG=C
export PATH=/usr/sbin:/usr/bin:/sbin:/bin

# Start with the installation of Docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user pi to group docker
sudo usermod -aG docker pi

# Install docker-compose
pip install docker-compose

# Create directories to run Node RED and Mosquitto containers
mkdir ~/Docker/{NodeRED, Mosquitto}

# Create docker-compose files for ease of use

cat << EOF > ~/Docker/Mosquitto/docker-compose.yml
version: '3'
services:
  mosquitto:
    image: "eclipse-mosquitto:latest"

    container_name: mosquitto
    hostname: mosquitto.local

    network_mode: host
    user: root

    ports:
     - "1883:1883"
     - "8883:8883"
     - "9001:9001"

    volumes:
     - config:/mosquitto/config/
     - logs:/mosquitto/log/
     - data:/mosquitto/data/
     - /etc/localtime:/etc/localtime:ro
     - /etc/timezone:/etc/timezone:ro

    restart: unless-stopped
volumes:
  config:
  logs:
  data:
EOF

cat << EOF > ~/Docker/NodeRED/docker-compose.yml
version: '3'
services:
  nodered:
    image: "nodered/node-red-docker"

    container_name: node-red
    hostname: node-red.local

    ports:
     - "1880:1880"

    volumes:
     - data:/data
     - /etc/localtime:/etc/localtime:ro

    cap_add:
     - NET_ADMIN

    user: root

    restart: unless-stopped

volumes:
  data:
EOF


# Start both containers
pushd .

cd ~/Docker/Mosquitto
docker-compose up -d


cd ~/Docker/NodeRED
docker-compose up -d

# Go down to be able to change the content of data volume
docker-compose down

# Copy a flow for NodeRED to get something working
sudo cp ../flows/flows.json /var/lib/docker/volumes/NodeRED_data/_data/flows.json

docker-compose up -d

popd
