#!/bin/bash

# Variables
IMAGE_URL=$(whiptail --inputbox 'Enter the URL for the FileCloud image (default: https://patch.codelathe.com/tonidocloud/live/vm/TonidoCloud_OVF.zip):' 8 78 'https://patch.codelathe.com/tonidocloud/live/vm/TonidoCloud_OVF.zip' --title 'FileCloud Installation' 3>&1 1>&2 2>&3)
RAM=$(whiptail --inputbox 'Enter the amount of RAM (in MB) for the new virtual machine (default: 4096):' 8 78 4096 --title 'FileCloud Installation' 3>&1 1>&2 2>&3)
CORES=$(whiptail --inputbox 'Enter the number of cores for the new virtual machine (default: 4):' 8 78 4 --title 'FileCloud Installation' 3>&1 1>&2 2>&3)

# Install unzip if missing
dpkg-query -s unzip &> /dev/null || { echo 'Installing unzip for FileCloud image decompression'; apt-get update; apt-get -y install unzip; }

# Get the next available VMID
ID=$(pvesh get /cluster/nextid)

touch "/etc/pve/qemu-server/$ID.conf"

# Get the storage name from the user
STORAGE=$(whiptail --inputbox 'Enter the storage name where the image should be imported:' 8 78 --title 'FileCloud Installation' 3>&1 1>&2 2>&3)

# Download FileCloud image
wget "$IMAGE_URL"

# Decompress the image
IMAGE_NAME=${IMAGE_URL##*/}
unzip "$IMAGE_NAME"
IMAGE_NAME=${IMAGE_NAME%.zip}
sleep 3

# Find the VMDK file in the extracted contents
VMDK_FILE=$(find . -name "*.vmdk" | head -n 1)
if [[ -z "$VMDK_FILE" ]]; then
    echo "Error: No VMDK file found in the extracted contents."
    exit 1
fi

# Import the VMDK file to the specified storage
echo "Importing disk image to storage..."
qm importdisk "$ID" "$VMDK_FILE" "$STORAGE"

# Retrieve the disk path for further usage and print for user
DISK_PATH=$(qm config "$ID" | awk '/unused0/{print $2;exit}')
if [[ $DISK_PATH ]]; then
    echo "Disk path: $DISK_PATH"
else
    echo "Error: Failed to import disk for VM $ID"
    exit 1
fi

# Set VM settings
qm set "$ID" --cores "$CORES"
qm set "$ID" --memory "$RAM"
qm set "$ID" --scsihw virtio-scsi-pci
qm set "$ID" --net0 'virtio,bridge=vmbr0'
qm set "$ID" --scsi0 "$DISK_PATH,discard=on,ssd=1"

# Verify if the disk was set correctly
if qm config "$ID" | grep -q "scsi0"; then
    qm set "$ID" --boot order='scsi0'
else
    echo "Error: Failed to set the disk for VM $ID"
    exit 1
fi

qm set "$ID" --name 'filecloud' >/dev/null
qm set "$ID" --description '### [FileCloud Website](https://www.getfilecloud.com/)
### [FileCloud Docs](https://www.getfilecloud.com/supportdocs/)
### [FileCloud Forum](https://www.getfilecloud.com/community/)
### [FileCloud Blog](https://www.getfilecloud.com/blog/)' >/dev/null

# Tell user the virtual machine is created  
echo "VM $ID Created."

# Start the virtual machine
qm start "$ID"
