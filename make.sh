echo "[!] Before we start we need to login to RedHat's registry"
echo "[*] Go to developers.redhat.com for a free subscription"
docker login registry.redhat.io || exit $?

docker build -t rhwsl8:local . || exit $?
docker run --name my-rhwsl8 rhwsl8:local true || exit $?
docker export my-rhwsl8 --output rootfs.tar || exit $?
docker rm my-rhwsl8 || exit $?
gzip rootfs.tar || exit $?

echo "[*] Now begin downloading wsldl."
echo "[*] After this, move RHWSL8.exe and rootfs.tar.gz to your installation directory."
curl -L https://github.com/yuk7/wsldl/releases/download/20040300/Launcher.exe -o RHWSL8.exe
