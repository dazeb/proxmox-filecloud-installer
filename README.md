![filecloud-logo](https://www.getfilecloud.com/wp-content/uploads/2020/11/filecloud-logo.png)

# FileCloud Proxmox Installer

An unofficial Proxmox Helper Script to install FileCloud in Proxmox 8.

## What is FileCloud?

[FileCloud](https://www.getfilecloud.com/) is a powerful, secure, and easy-to-use file sharing and sync solution for businesses. It offers a range of features including file sharing, synchronization, backup, and remote access. FileCloud is designed to provide a secure and efficient way to manage and share files across different devices and platforms.

This script installs the community edition of FileCloud. For more details, visit the [FileCloud Community Edition](https://ce.filecloud.com/) page.

## How to Use

There are two ways to install the FileCloud VM in Proxmox:

Either use the oneliner or download the script directly.

All commands should be run in the Proxmox console.

### Oneline Installer Directly from GitHub

```sh
bash <(curl -sSfL https://raw.githubusercontent.com/yourusername/proxmox-filecloud-installer/main/filecloud-install.sh)
```

### Download the Script to Your Proxmox Host by Cloning the Repo or Using `wget`

```sh
git clone https://github.com/yourusername/proxmox-filecloud-installer.git
```

cd into the folder, make the file executable then run the script

```sh
cd proxmox-filecloud-installer
chmod +x filecloud-install.sh
./filecloud-install.sh
```

#### Download Script to Your Machine Through

```sh
wget https://raw.githubusercontent.com/yourusername/proxmox-filecloud-installer/main/filecloud-install.sh
```

Make the file executable then run the script.

```sh
chmod +x filecloud-install.sh
./filecloud-install.sh
```

The installer will ask for the URL of the FileCloud image, the amount of RAM to allocate, and the number of processor cores. The rest is automatic. Default values are 4GB RAM and 4 Cores.

## Tested and Confirmed Working with Proxmox 8.x

For more helper scripts like this, check out [tteck's Proxmox Helper Scripts](https://tteck.github.io/Proxmox/)

## Disclaimer

This script is unofficial and not affiliated with or endorsed by FileCloud. Use it at your own risk.
