#!/bin/bash

GIT_NAME='Henrique Morais'
GIT_EMAIL='rikeaju@hotmail.com'
FAIL='e\[1;91m'
DONE='e\[1;92m'
UNCOLOR='\e[0m'

PACMAN_PACKAGES=(
  base-devel
  firefox
  git
  gufw
  nano
  neofetch
  ntfs-3g
)

YAY_PACKAGES=(
  spotify
  google-chrome
  zed
)

if ! ping -c 8.8.8.8 -q &> /dev/null/; then
  echo -e "${FAIL} ❌ Without Internet Connection ${UNCOLOR}"
  exit 1
else
  echo -e "${DONE} ✅ Computer Has Internet Connection ${UNCOLOR}"
fi

echo "⌛ Updating Arch Linux"
sudo pacman -Syu --noconfirm &> /dev/null
echo "✅ Arch Linux Updated"

echo "⌛ Activating Bluetooth"
sudo systemctl start bluetooth.service --now &> /dev/null
echo "✅ Bluetooth Activated"

installations_pacman () {
  echo "⌛ Installing Pacman Programs"
  for program in "${PACMAN_PACKAGES[@]}"
  do
    if ! dpkg -l | grep -q "$program"; then
      sudo pacman -S "$program" --noconfirm &> /dev/null
    else
      echo "✅ The Package $program Already Installed"
    fi
    echo "⌛ Installing '$program'"
  echo -e "${DONE} ✅ Pacman Programs Installed ${UNCOLOR}"
  done
}

install_yay () {
  if ! command -v yay &> /dev/null; then
    echo "⌛ Yay Not Found, Installing"
    git clone https://aur.archlinux.org/yay.git &> /dev/null
    cd yay || exit
    makepkg -si --noconfirm &> /dev/null
    cd .. && rm -rf yay &> /dev/null
    echo "✅ Yay Installed Successfully"
  else
    echo "⏭️ Yay Is Already Installed"
  fi
}

installations_yay () {
  echo "⌛ Installing YAY Programs"
  for program in "${YAY_PACKAGES[@]}"
  do
    if ! yay -Q "$program" &>/dev/null; then
      sudo yay -S "$program" --noconfirm &> /dev/null
    else
      echo "✅ The Package $program Already Installed!"
    fi
    echo "⌛ Installing '$program'"
  echo "✅ YAY Programs Installed"
  done
}

installations_pacman
install_yay

echo "⌛ Setting Git"
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "✅ Git Setup Finished"
git config --list
echo "✅ All Installations Are Done!"

read -r -p "⁉️ Would you like to refresh the pacman keys? (Y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
  echo "⌛ Refreshing Pacman Keys"
  sudo pacman-key --refresh-keys
  echo "✅ Pacman Keys Refreshed"
else
  echo "⏭️ Skipping Pacman Key Refresh"
fi
echo -e "${DONE} ✅ Script Finished! ${UNCOLOR}"
