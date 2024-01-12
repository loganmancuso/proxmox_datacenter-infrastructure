#!/bin/bash
##############################################################################
#
# Author: Logan Mancuso
# Created: 11.10.2023
#
##############################################################################

# Redirect all output to log file
exec > >(tee -a "${log_dst}") 2>&1

# Function to map arguments to local variables
function map_arguments() {
  OPTS=$(getopt -o p1:p2: --long param1:param2: -- "$@")
  if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi
  eval set -- "$OPTS"
  while true; do
    case "$1" in
      -p1 | --param1 ) PARAM1="$2"; shift ;;
      -p2 | --param2 ) PARAM2="$2"; shift ;;
      -- ) shift; break ;;
      * ) break ;;
    esac
  done
  echo -e "END:\tmap_arguments"
}

# Helper function
function helper() {
  echo -e "START:\thelper"
  # Remove prod pve subscription
  rm -f /etc/apt/sources.list.d/pve-enterprise.list
  # Remove prod ceph subscription
  rm -f /etc/apt/sources.list.d/ceph.list
  # Create new sources list
  echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-nosub.list
  apt -y update
  apt -y upgrade
  # install helper tools
  apt install -y neovim python3-full python3-pip python3-jsondiff git wget curl unzip lshw libsasl2-modules mailutils
  mkdir -p /var/log/tofu
  chown -R root:root /var/log/tofu
  chmod -R u+rwx,g+rwx /var/log/tofu
  mkdir -p /opt/tofu/
  chown -R root:root /opt/tofu
  chmod -R u+rwx,g+rwx /opt/tofu
  apt install -y git unzip wget fontconfig
  mkdir -p ~/.local/share/fonts
  wget -O ~/.local/share/fonts/CascadiaCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
  unzip ~/.local/share/fonts/CascadiaCode.zip -d ~/.local/share/fonts
  fc-cache -fv
  mkdir -p ~/.config
  git clone https://gitlab.com/snippets/2295216.git ~/.config/bash
  git clone https://gitlab.com/snippets/2351345.git ~/.config/oh-my-posh
  wget -qO- https://ohmyposh.dev/install.sh | bash -s
  echo "source ~/.config/bash/bash_aliases" >> ~/.bashrc
  # remove pve notification of missing subscription
  wget -O /opt/tofu/pve-nag.sh https://raw.githubusercontent.com/foundObjects/pve-nag-buster/master/install.sh 
  chmod +x pve-nag.sh && ./pve-nag.sh
  echo -e "END:\thelper"
}

# Main function
function main() {
  echo -e "START:\tmain"
  echo "Waiting for cloud-init to finish"
  cloud-init status --wait
  echo "System information:"
  echo "Hostname: $(hostname)"
  echo "CPU usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
  echo "Memory usage: $(free | grep Mem | awk '{print $3/$2 * 100.0"%"}')"
  map_arguments "$@"
  helper
  echo -e "END:\tmain"
}

# Start the script
main "$@"