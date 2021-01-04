#!/bin/bash

VM=okd-hub

CPU_COUNT=1
RAM_SIZE=4096
DISK_SIZE=81920

INTNET_NAME=intnet
VBOXNET_NAME=vboxnet0

ISO_PATH=/mnt/data/Repo/centos/7/isos/CentOS-7-x86_64-DVD-2009.iso
DISK_PATH="$VBOX_USER_HOME/$VM/$VM.vdi"
KS_PATH=$(realpath ../unattended/hub_ks.cfg)
POST_PATH=$(realpath ../unattended/dummy_postinstall.sh)

if [ ! -d "$VBOX_USER_HOME" ]; then
  echo "Virtual Box home directory does not exist: $VBOX_HOME" 1>&2
  exit 3
fi
if [ ! -f "$ISO_PATH" ]; then
  echo "Installation iso not found: $ISO_PATH" 1>&2
  exit 3
fi
if [ ! -f "$KS_PATH" ]; then
  echo "Kickstart template not found: $KS_PATH" 1>&2
  exit 3
fi
if [ ! -f "$POST_PATH" ]; then
  echo "Postinstall template not found: $POST_PATH" 1>&2
  exit 3
fi


# Create machine
VBoxManage createvm --register --basefolder "$VBOX_USER_HOME" --name $VM --ostype RedHat_64
# Setup system resources
VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --cpus $CPU_COUNT
VBoxManage modifyvm $VM --memory $RAM_SIZE
# Setup network
VBoxManage modifyvm $VM --nic1 intnet --intnet1 $INTNET_NAME --macaddress1 080027180001
VBoxManage modifyvm $VM --nic2 nat
VBoxManage modifyvm $VM --nic3 hostonly --hostonlyadapter3 $VBOXNET_NAME
# Create disk
VBoxManage createmedium --filename "$DISK_PATH" --size $DISK_SIZE
VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$DISK_PATH"
# Mount ISO image
VBoxManage storagectl $VM --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $VM --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"
# Setup boot order
VBoxManage modifyvm $VM --boot1 disk --boot2 dvd --boot3 none --boot4 none
# Unattended install
VBoxManage unattended install $VM --iso="$ISO_PATH" --start-vm=gui --script-template="$KS_PATH" --post-install-template="$POST_PATH"
