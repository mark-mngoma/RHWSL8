#! /bin/bash

echo
echo "[*] Executing RHWSL8 post-installation procedure"
echo

echo "[*] Registering & Installing Server environment group"
subscription-manager register --auto-attach || exit $?
dnf groupinstall -y --allowerasing "Server" || exit $?
passwd || exit $?

echo "[*] Creating new regular user with UID 1000"
read -p "New UNIX username: " -r wsl_username
groupdel -f docker || ( code=$?; [[ $code != '6' ]] && exit $code )
useradd -u 1000 -G wheel $wsl_username || exit $?
passwd $wsl_username || exit $?

groupadd docker || exit $?
usermod -aG docker $wsl_username || exit $?

mv -f .bashrc~ .bashrc || exit $?
rm -f post-install.sh || exit $?

source .bashrc
