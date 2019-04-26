# Setting up a MQTT Broker

The easiest MQTT broker to setup is Mosquitto. 
Mosquitto can be run inside a Docker container but a native installation is also possible.

To simplify the setup a couple of scripts are provided to make the setup easy. These scripts are ment to run on a Raspberry Pi with a fresh installation of Raspbian.


* Login as the user `pi` on a Raspberry Pi with a fresh installation of Raspbian. 
* Open a terminal session
* Enter the following commands:

```bash
git clone https://github.com/mverleun/Wow
cd Wow
```

## Option 1, with Docker
For this setup we will use a Raspberry Pi and install Docker first. Once Docker is up and running we will start a couple of containers: One for Mosquitto and one for Node RED. You can also use any other system that is capable of running Docker containers to host the services.

The instructions to install Docker can be found here: https://docs.docker.com/install/linux/docker-ce/debian/
Make sure to reboot the Pi afterwards.

In brief the installation steps are repeated below:

* Login as the user pi on a Raspberry Pi. 
* Open a terminal session and type the following commands:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```
* Wait for it to complete and then add the user pi to the docker group:
```
sudo usermod -aG docker pi
```
Be carefull, this gives the user pi full control over the host system! On a Raspberry Pi the user pi has the ability to use `sudo` anyway, but on many production systems you might skip this step.

## Option 2, bare metal installation
The software installation can be done 'old school' as well. It's simply typing a couple of commands and waiting for them to complete.

Enter the following commands to get everything up and running:

```bash
sudo apt update
sudo apt install -y mosquitto mosquitto-clients nodered npm

cd ~/.node-red
npm install node-red-contrib-web-worldmap
npm install node-red-contrib-owntracks

sudo systemctl enable --now nodered
```

Enter the following URL on any workstation that is able to connect with the system running Node RED and enter the following URL:
`http:<ip of node-red>:1880` and press enter.


Select and copy the JSON formatted text below with your mouse. 

```json
[
    {
        "id": "10016e5.15bdc12",
        "type": "mqtt in",
        "z": "712b7a52.56bd7c",
        "name": "",
        "topic": "owntracks/#",
        "qos": "0",
        "broker": "5df56435.f281ec",
        "x": 171.5,
        "y": 214,
        "wires": [
            [
                "203498bc.ca3be8"
            ]
        ]
    },
    {
        "id": "203498bc.ca3be8",
        "type": "owntracks",
        "z": "712b7a52.56bd7c",
        "x": 394.5,
        "y": 213,
        "wires": [
            [
                "58e95381.8ed814"
            ]
        ]
    },
    {
        "id": "58e95381.8ed814",
        "type": "worldmap",
        "z": "712b7a52.56bd7c",
        "name": "",
        "lat": "",
        "lon": "",
        "zoom": "",
        "layer": "",
        "cluster": "",
        "maxage": "",
        "usermenu": "show",
        "layers": "show",
        "panit": "false",
        "panlock": "false",
        "zoomlock": "false",
        "hiderightclick": "false",
        "coords": "false",
        "path": "/worldmap",
        "x": 611.5,
        "y": 213,
        "wires": []
    },
    {
        "id": "5df56435.f281ec",
        "type": "mqtt-broker",
        "z": "",
        "name": "",
        "broker": "localhost",
        "port": "1883",
        "clientid": "",
        "usetls": false,
        "compatmode": true,
        "keepalive": "60",
        "cleansession": true,
        "birthTopic": "",
        "birthQos": "0",
        "birthRetain": "false",
        "birthPayload": "",
        "closeTopic": "",
        "closeQos": "0",
        "closeRetain": "false",
        "closePayload": "",
        "willTopic": "",
        "willQos": "0",
        "willRetain": "false",
        "willPayload": ""
    }
]
```
