#!/bin/bash

# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]
    then
    echo -e "\033[0;32m[PACMAN]\033[0m adding extra spice to pacman..."

    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf

    #if [ $(grep -w "^\[xero_hypr\]" /etc/pacman.conf | wc -l) -eq 0 ] && [ $(grep "https://repos.xerolinux.xyz/xero_hypr/x86_64/" /etc/pacman.conf | wc -l) -eq 0 ]
    #    then
    #    echo "adding [xero_hypr] repo to pacman..."
    #    echo -e "\n[xero_hypr]\nSigLevel = Required DatabaseOptional\nServer = https://repos.xerolinux.xyz/xero_hypr/x86_64/\n\n" | sudo tee -a /etc/pacman.conf
    #fi
    sudo pacman -Syyu
    sudo pacman -Fy

else
    echo -e "\033[0;33m[SKIP]\033[0m pacman is already configured..."
fi

# Define text file name (change "packages.txt" if needed)
PACKAGES_FILE="pkg_list.txt"

# Check if package list file exists
if [ ! -f "$PACKAGES_FILE" ]; then
  echo "Error: Package list file '$PACKAGES_FILE' not found."
  exit 1
fi

# Loop through packages in the file
while IFS= read -r package; do
  # Check if package is already installed
  if pacman -Qi "$package" &> /dev/null; then
    echo "$package is already installed, skipping."
  else
    echo "Installing package: $package"
    sudo pacman -S "$package"
  fi
done < "$PACKAGES_FILE"

echo "Package installation complete!"
