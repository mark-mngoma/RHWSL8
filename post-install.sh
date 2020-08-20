#!/bin/bash
pushd /root > /dev/null

distro_name="RHWSL8"

echo
echo "[*] Executing $distro_name post-installation procedure"

echo
echo "[*] Registering & Installing Server environment group"
subscription-manager register --auto-attach
dnf groupinstall -y --allowerasing "Server" || exit $?

echo
passwd || exit $?

echo
echo "[*] Creating new regular user with UID 1000"
read -p "New username: " -r wsl_username
groupdel -f docker
useradd -u 1000 -G wheel $wsl_username || exit $?

echo
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/allow-wheels-nopasswd
passwd $wsl_username || exit $?

groupadd docker || exit $?
usermod -aG docker $wsl_username || exit $?

mv -f .bashrc~ .bashrc || exit $?
rm -f post-install.sh || exit $?

echo
popd > /dev/null
