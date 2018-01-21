#!/bin/bash

sudo wget http://node-arm.herokuapp.com/node_latest_armhf.deb
sudo dpkg -i node_latest_armhf.deb
sudo apt-get install -y npm
sudo apt-get install -y git

cd /home/pi/
git clone https://github.com/MichMich/MagicMirror
cd MagicMirror
sudo npm install #This will take a LONG time, expect 30 minutes

sudo apt-get install -y unclutter
sudo aptitude install -y xinit
sudo apt-get install -y matchbox

# THis step needs to be done manually
sudo raspi-config #-> Boot Options -> B1 Desktop/CLI -> B2 Console Autologin

sudo cat >> /home/pi/start.sh << EOF
#! /bin/bash
cd ~/MagicMirror
node serveronly &
sleep 45
sudo xinit /home/pi/startDisplay.sh
EOF

# Place the start.sh script in the init.d dir for automatic launch on boot
sudo chmod a+x /home/pi/start.sh
sudo mv /home/pi/start.sh /etc/init.d/startMagicMirror.sh
sudo update-rc.d startMagicMirror.sh defaults 100
sudo apt-get install -y x11-xserver-utils

sudo cat >> /home/pi/startDisplay.sh << EOF
#!/bin/sh
xset -dpms # disable DPMS (Energy Star) features.
xset s off # disable screen saver
xset s noblank # don’t blank the video device
matchbox-window-manager &
unclutter &
chromium-browser --start-maximized --incognito --kiosk --no-default-browser-check http://localhost:8080
EOF
