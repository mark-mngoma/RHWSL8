![rhwsl8](https://user-images.githubusercontent.com/29014642/89607890-30049980-d8a6-11ea-9374-42569aab3f84.PNG)

![rhwsl8-systemd](https://user-images.githubusercontent.com/29014642/89607996-73f79e80-d8a6-11ea-9641-477290e42611.PNG)

# Reason & Notes

The rootfs tarball of RHWSL built by yosukes has permission issues, causing the installation almost totally unusable. Therefore, I carried out my own implementation.

After seriously studying the [End User License Agreement for the Red Hat Universal Base Image](https://www.redhat.com/licenses/EULA_Red_Hat_Universal_Base_Image_English_20190422.pdf), non-commercial redistribution of RHUBI is permittable. Besides, carrying the RED HAT mark is also permitted by default in this scenario.

Therefore, In the following commits, a pre-baked rootfs tarball shipping `genie` executable will be pushed into GitHub Release, so users don't have to bake them on their own. The usage of another WSL 2 instance with Docker access can also be omitted.

However I'd still expect that it's user's responsibility to gain full RHEL 8 experience using their own subscriptions. :)

# Pre-Installation & Installation

Update: Since `genie` is shipped with this rootfs tarball, make sure the default install version for new WSL distro is 2.

```
wsl --set-default-version 2
```

Run `install.sh` to bake the RHWSL8 rootfs tarball, register the distro and bootstrap a full RHEL 8 experience. This requires you to have a working instance of WSL 2 distro (e.g. Debian 10 from Windows Store) with Docker access.

```
wsl bash install.sh
```

# Post-Installation

1. If you want to utilise systemd, use `genie -s` at the price that losing the integration with Windows environment.

```
wsl -d rhwsl8 genie -s
```

If you use Windows Terminal, you might want to add `"commandline": "wsl -d rhwsl8 genie -s",` to RHWSL8's configuration object.

2. Register your installation with `subscription-manager` and install the `Server` environment group for a full RHEL 8 experience.

Update: This is no longer needed due to the `post-install.sh` script.

```
subscription-manager --register --auto-attach
dnf groupinstall --allowerasing "Server"
```

3. Do not attempt to execute any power management command while the systemd bottle is activated, always use `wsl -t` or `wsl --shutdown`. You've been warned.

```
# Don't do
systemctl reboot || systemctl poweroff

# Do
wsl -t rhwsl8 || wsl --shutdown
```

# Known issues

1. Sometimes `genie` may fail to initialise, yielding `Failed to create CoreCLR, HRESULT: 0x80004005`. Remember to terminate RHWSL8 instance on seeing this.

Update: It looks like `genie -u` is the main cause of this problem, which also breaks mounting in all WSL 2 instances. The workaround is avoid using `genie -u`, use `wsl -t` or `wsl --shutdown` if you have to.

```
# Don't do
wsl -d rhwsl8 genie -u

# Do
wsl -t rhwsl8 || wsl --shutdown
wsl -d rhwsl8   # go ahead without systemd
```

2. SELinux doesn't work. It's because the default WSL 2 kernel is not a SELinux kernel. I may compile a custom WSL 2 kernel for this, but that would be another story.

# Special thanks

This method would not be possible without the elegant work of `genie` by Arkane Systems and `wsldl` by yuk7. Really appreciated your work, Mr. Arkane and yuk-san ;)

# Future features

- Xorg support for GUI applications, with Xserver deployed at Windows environment

- Ship a custom WSL 2 kernel with SELinux support
