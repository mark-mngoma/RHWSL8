#! /bin/bash

echo
echo "[*] Before we start we need to login to RedHat's registry"
echo "[*] Go to developers.redhat.com for a free subscription"
read -p "Red Hat login: " -r rh_login
read -p "Password: " -rs rh_passwd
echo

echo $rh_passwd | docker login registry.redhat.io --username=$rh_login --password-stdin || exit $?
export rh_login rh_passwd

echo "[*] Baking RHWSL8 rootfs tarball"
docker build -t rhwsl8:local . || exit $?
docker run --name my-rhwsl8 rhwsl8:local true || exit $?
docker export my-rhwsl8 --output rootfs.tar || exit $?
docker rm my-rhwsl8 || exit $?
gzip -f rootfs.tar || exit $?

echo "[*] Baking complete"
echo

echo "[*] source ./post-install.bash"
source ./post-install.sh
