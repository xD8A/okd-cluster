#!/bin/bash

VM=okd-bootstrap

CPU_COUNT=1
RAM_SIZE=4096
DISK_SIZE=20480

INTNET_NAME=intnet

DISK_PATH="$VBOX_USER_HOME/$VM/$VM.vdi"

if [ ! -d "$VBOX_USER_HOME" ]; then
  echo "Virtual Box home directory does not exist: $VBOX_USER_HOME" 1>&2
  exit 3
fi

# Create machine
VBoxManage createvm --register --basefolder "$VBOX_USER_HOME" --name $VM --ostype Fedora_64
# Setup system resources
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --cpus $CPU_COUNT
VBoxManage modifyvm $VM --memory $RAM_SIZE
# Setup network
VBoxManage modifyvm $VM --nic1 intnet --intnet1 $INTNET_NAME --macaddress1 080027180200
# Create disk 
VBoxManage createmedium --filename "$DISK_PATH" --size $DISK_SIZE
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$DISK_PATH"
# Setup boot order
VBoxManage modifyvm $VM --boot1 dvd --boot2 net --boot3 disk --boot4 none
