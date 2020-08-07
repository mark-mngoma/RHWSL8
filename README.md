![rhwsl8](https://user-images.githubusercontent.com/29014642/89607890-30049980-d8a6-11ea-9374-42569aab3f84.PNG)

![rhwsl8-systemd](https://user-images.githubusercontent.com/29014642/89607996-73f79e80-d8a6-11ea-9641-477290e42611.PNG)

# Reason & Notes

The rootfs tarball of RHWSL built by yosukes has permission issues, causing the installation almost totally unusable. Therefore, I carried out my own implementation.

Please note that anyone who's redistributing RHEL 8 binaries or private images to any other 3rd parties is violating RHEL's EULA. This repository, while not including any Red Hat binaries at all, just provides a script that helps you install RHEL 8 on WSL 2, **using your own legal candidates**.

# Pre-Installation & Installation

Run `make.sh` to bake the RHWSL8 rootfs tarball. This requires you to have a working instance of WSL 2 distro (e.g. Debian10 from Windows Store) with Docker access.

```
wsl sh make.sh
```

# Post-Installation

1. Use `genie -s` to utilise the systemd at the price that losing the integration with Windows environment.

```
wsl -d RHWSL8 genie -s
```

If you use Windows Terminal, you might want to add `"commandline": "...\\RHWSL8.exe run genie -s",` to RHWSL8's configuration object.

2. Register your installation with `subscription-manager` and install the 'Minimal Install' environment group for a full RHEL 8 experience.

```
subscription-manager --register --auto-attach
dnf groupinstall --allowerasing "Minimal Install"
```

3. Do not attempt to execute any power management command while the systemd bottle is activated, always use `wsl -t`. You've been warned.

```
# Don't do
systemctl shutdown || systemctl reboot

# Do
wsl -t RHWSL8
```

# Known issues

1. Sometimes `genie` may fail to initialise, reporting `Failed to create CoreCLR, HRESULT: 0x80004005`. Remember to terminate RHWSL8 instance on seeing this.

Update: It looks like `genie -u` is the main cause of this problem, which also breaks mounting in all WSL 2 instances. The workaround is avoid using `genie -u`, use `wsl -t` if necessary.

2. SELinux doesn't work. It's because the default WSL 2 kernel is not a SELinux kernel. I may compile a custom WSL 2 kernel for this, but that would be another story.

# Special thanks

This method would not be possible without the elegant work of `genie` by Arkane Systems and `wsldl` by yuk7. Really appreciated your work, Mr. Arkane and yuk-san ;)
