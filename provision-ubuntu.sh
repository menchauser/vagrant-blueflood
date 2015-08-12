#!/usr/bin/env bash

# Update all
sudo apt-get update

# Set up VirtualBox guest extensions
sudo apt-get install -y linux-headers-generic build-essential dkms

wget http://download.virtualbox.org/virtualbox/4.3.28/VBoxGuestAdditions_4.3.28.iso
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_4.3.28.iso /media/VBoxGuestAdditions
yes | sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm VBoxGuestAdditions_4.3.28.iso
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions
