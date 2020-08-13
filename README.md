![rhwsl8](https://user-images.githubusercontent.com/29014642/89607890-30049980-d8a6-11ea-9374-42569aab3f84.PNG)

![rhwsl8-systemd](https://user-images.githubusercontent.com/29014642/89607996-73f79e80-d8a6-11ea-9641-477290e42611.PNG)

# Reason for this

The rootfs tarball of RHWSL built by yosukes has permission issues, causing the installation almost totally unusable. Therefore, I carried out my own implementation.

After seriously studying the [End User License Agreement for the Red Hat Universal Base Image](https://www.redhat.com/licenses/EULA_Red_Hat_Universal_Base_Image_English_20190422.pdf), non-commercial redistribution of RHUBI is allowed.

Therefore, from now on a pre-baked WSL 2 distro, will be published through GitHub Releases. Users don't have to bake them on their own any longer. The usage of another WSL 2 instance with Docker access will also be omitted.

However, shipping RHEL binaries is still considered as inappropriate, and therefore users still need to provide their own subscriptions to gain a full RHEL 8 experience.

# Pre-Installation & Installation

1. Since `genie` is shipped, make sure the default install version for new WSL distro is two.

```
wsl --set-default-version 2
```

2. Download and extract your `RHWSL8-release-*.tar` to somewhere you have write permission, execute `RHWSL8.exe` once for registering to WSL, execute twice for post-installation procedure, execute a third time to enjoy your RHEL experience.

![post-install-1](https://user-images.githubusercontent.com/29014642/90122235-8d5d8680-dd8f-11ea-923b-a67a9b406514.PNG)

![post-install-2](https://user-images.githubusercontent.com/29014642/90122257-94849480-dd8f-11ea-827a-12497dc54b44.PNG)

# Post-Installation

1. If you want to utilise systemd, use `genie -s` at the price that losing the integration with Windows environment.

```
wsl -d rhwsl8 genie -s
```

If you use Windows Terminal, you might want to add `"commandline": "wsl -d rhwsl8 genie -s",` to RHWSL8's configuration object.

2. You may consider utilising your distro with a regular user, rather than the default root user. In the installation directory, issue the following command to do this.

```
./RHWSL8.exe config --default-uid 1000
```

3. Do not attempt to execute any power management command while the systemd bottle is activated, always use `wsl -t` or `wsl --shutdown`. You've been warned.

```
# Don't do
systemctl reboot || systemctl poweroff

# Do
wsl -t rhwsl8 || wsl --shutdown
```

# Known issues

1. Executing `genie -u` may break the whole WSL 2 Utility VM, yielding `Failed to create CoreCLR, HRESULT: 0x80004005` and causing broken mount on every WSL 2 instance. The workaround is avoid using `genie -u`, use `wsl -t` or `wsl --shutdown` when you need to.

Update: In the latest `1.27` release of `genie`, this issue is resolved. However, mounting is still laggy and will cause `The command 'docker' could not be found in this WSL 2 distro.` when you issue `docker` in any WSL distro. Therefore, it's still recommended to use `wsl -t` or `wsl --shutdown` from this perspective.

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
