# https://docs.fedoraproject.org/en-US/fedora/f30/install-guide/appendixes/Kickstart_Syntax_Reference/

# Configure installation method
install
url --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-30&arch=x86_64"
repo --name=fedora-updates --mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f30&arch=x86_64" --cost=0
repo --name=rpmfusion-free --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-30&arch=x86_64" --includepkgs=rpmfusion-free-release
repo --name=rpmfusion-free-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-30&arch=x86_64" --cost=0
repo --name=rpmfusion-nonfree --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-30&arch=x86_64" --includepkgs=rpmfusion-nonfree-release
repo --name=rpmfusion-nonfree-updates --mirrorlist="https://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-30&arch=x86_64" --cost=0

# zerombr
zerombr

# Configure Boot Loader
bootloader --location=mbr --driveorder=sda

# Create Physical Partition
part /boot --size=512 --asprimary --ondrive=sda --fstype=xfs
part swap --size=10240 --ondrive=sda
part / --size=8192 --grow --asprimary --ondrive=sda --fstype=xfs

# Remove all existing partitions
clearpart --all --initlabel --drives=sda

# Configure Firewall
firewall --enabled --ssh

# Configure Network Interfaces
network --onboot=yes --bootproto=dhcp --hostname=user

# Configure Keyboard Layouts
keyboard ru

# Configure Language During Installation
lang en_US

# Configure X Window System
xconfig --startxonboot

# Configure Time Zone
timezone Europe/Saratov

# Create User Account
user --name=user --plaintext --password=Q1w2e3r4@ --groups=wheel


# Set Root Password
rootpw --lock

# Perform Installation in Text Mode
text

# Package Selection
%packages

chromium
java-latest-openjdk
@Python Classroom
firefox
@LibreOffice
@gnome-desktop
git
vim
ansible
docker

%end

# Post-installation Script
%post
sudo systemctl start docker
sudo systemctl enable docker
curl -o /usr/bin/containers.sh https://raw.githubusercontent.com/bibichevat/kickstart-fedora-workstation/master/containers.sh
chmod +x /usr/bin/containers.sh
curl -o /etc/systemd/system/containers.service https://raw.githubusercontent.com/bibichevat/kickstart-fedora-workstation/master/containers.service
chmod 644 /etc/systemd/system/containers.service
systemctl enable containers.service
%end

# Reboot After Installation
reboot --eject
