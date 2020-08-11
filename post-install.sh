#! /bin/bash

echo
echo "[*] Executing RHWSL8 post-installation procedure"
echo "[*] If anything goes wrong from this step on, just re-run post-install.sh"
echo

default_name="RHWSL8"
read -p "Distro name [$default_name]: " -r distro_name
[[ -z $distro_name ]] && distro_name=$default_name

echo "[*] Downloading wsldl"
curl -L https://github.com/yuk7/wsldl/releases/download/20040300/Launcher.exe -o $distro_name.exe || exit $?
chmod +x $distro_name.exe || exit $?

./$distro_name.exe || exit $?
wsl-exec() { wsl.exe -d $distro_name "$@"; }
wsl-term() { wsl.exe -t $distro_name "$@"; }

env-setup() {
    echo "[*] Installing Server environment group"
    wsl-exec genie -i || return $?

    if [[ -n $rh_login ]] && [[ -n $rh_passwd ]]; then
        wsl-exec subscription-manager register --username=$rh_login --password=$rh_passwd --auto-attach || return $?
    else
        wsl-exec subscription-manager register --auto-attach || return $?
    fi

    wsl-exec dnf groupinstall -y --allowerasing "Server" || return $?
    wsl-exec passwd || return $?

    echo "[*] Creating new regular user with UID 1000"
    read -p "New UNIX username: " -r wsl_username
    wsl-exec groupdel -f docker || ( code=$?; [[ $code != '6' ]] && return $code )
    wsl-exec useradd -u 1000 -G wheel $wsl_username || return $?
    wsl-exec passwd $wsl_username || return $?

    wsl-exec groupadd docker || return $?
    wsl-exec usermod -aG docker $wsl_username || return $?
}

env-setup || ( code=$?; wsl-term || exit $?; exit $code )
wsl-term || exit $?

./$distro_name.exe config --default-uid 1000 || exit $?
