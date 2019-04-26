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


# Update the package managment system
sudo apt update

# Install a few packages
sudo apt install -y mosquitto mosquitto-clients nodered npm

# Install additional nodes for Node RED
mkdir -p ~/.node-red
cd ~/.node-red
npm install node-red-contrib-web-worldmap
npm install node-red-contrib-owntracks

# Start the services
sudo systemctl enable --now mosquitto
sudo systemctl enable --now nodered
