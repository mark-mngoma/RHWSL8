#!/bin/bash

distro_name="RHWSL8"
image_name="rhwsl8-rootfs:local"

echo
echo "[*] Baking $distro_name rootfs tarball"
docker build -t $image_name . || exit $?

container_name=$(docker create $image_name || exit $?)
docker export $container_name --output rootfs.tar || exit $?
docker rm $container_name || exit $?

gzip -f rootfs.tar || exit $?
mkdir -p $distro_name out || exit $?
mv rootfs.tar.gz $distro_name || exit $?
echo "[*] Baking complete"

echo
echo "[*] Downloading wsldl"
curl -L https://github.com/yuk7/wsldl/releases/download/20040300/Launcher.exe \
    -o $distro_name/$distro_name.exe || exit $?

echo
echo "[*] Downloading RH icon"
curl -L https://www.redhat.com/misc/favicon.ico -o $distro_name/redhat.ico || exit $?

echo
echo -n "[*] Packaging for publish... "
tar -cf out/$distro_name-release.tar $distro_name && echo "done!" || exit $?
