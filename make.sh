#! /bin/bash

echo
echo "[*] Baking RHWSL8 rootfs tarball"
docker build -t rhwsl8-rootfs:local . || exit $?

container_name=$(docker create rhwsl8-rootfs:local || exit $?)
docker export $container_name --output rootfs.tar || exit $?
docker rm $container_name || exit $?

gzip -f rootfs.tar || exit $?
echo "[*] Baking complete"
echo

echo "[*] Downloading wsldl and RH icon"
mkdir -p RHWSL8 out || exit $?
mv rootfs.tar.gz RHWSL8 || exit $?
curl -L https://github.com/yuk7/wsldl/releases/download/20040300/Launcher.exe -o RHWSL8/RHWSL8.exe || exit $?
curl -L https://www.redhat.com/misc/favicon.ico -o RHWSL8/redhat.ico || exit $?

echo "[*] Packaging for publish"
tar -cf out/RHWSL8-release.tar RHWSL8 || exit $?
