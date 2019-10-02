# NIXOS Complete Installation Guide

## Getting Started
* Download an iso from [----HERE----](https://nixos.org/nixos/download.html)
* Deactivate secure boot in your bios
* Boot from your ISO
* Now change your keyboard layout to whatever yo need:
```
$ loadkeys de
```
To find a list of possible keymaps execute:
```
$ find $(nix-build '<nixpkgs>' --no-out-link -A kbd)/share/keymaps
```

## EFI Install

* IMPORTANT: Your disk has to have a gpt partition table for EFI to install properly.
To make this happen use 'parted' and execute the following:
```
$ parted /dev/yourLinuxFilesystem

(parted) mktable GPT
(parted) q
```
You now have successfully created a gpt parition table on your drive. If you go into cfdisk check at the top if the 'Label' field indicates 'gpt'.

If your bios does not support EFI jump to the 'Bios Install' section below.

It is a good idea to create the SWAP parition as big as your installed RAM.
This enables the feature to [hibernate](https://en.wikipedia.org/wiki/Hibernation_(computing)) your Linux without running into problems.
Now create your partitions with cfdisk:
 ```
$ cfdisk
--> Create a 1GB partition of type 'EFI'
--> Create a X-GB partition of type 'SWAP'
--> Create a parition that fills out the rest and is of type 'Linux Filesystem'
--> Write to disk and exit
```

Now on to the drive encryption phase:
```
$ cryptsetup luksFormat /dev/yourLinuxFilesystem (Example: /dev/sda2)
$ cryptsetup luksOpen /dev/yourLinuxFilesystem someName
$ mkfs.fat -F 32 -n boot /dev/yourEfi (Example: /dev/sda1)
$ mkswap -L swap /dev/yourSwap (Example: /dev/sda3)
$ mkfs.ext4 -L nixos /dev/mapper/someName
$ mount /dev/mapper/someName /mnt
$ mkdir /mnt/boot
$ mount /dev/yourEfi /mnt/boot
$ nixos-generate-config --root /mnt
```
Your generated configurations now are at /mnt/etc/nixos.
Edit the configuration.nix and uncomment the following lines:
```
i18n = {
  consoleFont = "Lat2-Terminus16";
  consoleKeyMap = "de";
  defaultLocale = "en_US.UTF-8";
};
```
Change the 'consoleKeyMap' option to the keymap you set at the beginning. This is important or your password may be differently typed at bootup.

Remove following lines in the configuration.nix:
```
# boot.loader.grub.enable = true;
# boot.loader.grub.version = 2;
```

Now add the following lines to the configuration.nix:
```
boot.loader.systemd-boot.enable = true;
boot.loader.efi.efiSysMountPoint = "/boot";
boot.loader.efi.canTouchEfiVariables = true;
```

Make sure to have internet access. If you don't have a LAN connection
configure WPA supplicant so we can use WIFI:
```
$ cat > /etc/wpa_supplicant.conf
network={
  ssid="****"
  psk="****"
}
$ systemctl start wpa_supplicant
```

Before copying your nixos configs over you want to be sure to be able to boot.
So install this minimal installation config with:

```
$ nixos-install
$ reboot
```

If you don't boot into your nixos go to the section 'Trouble Shooting'

## BIOS Install

* IMPORTANT: Your disk has to have a dos partition table for Grub to install properly.
To make this happen use 'parted' and execute the following:
```
$ parted /dev/yourLinuxFilesystem

(parted) mktable msdos
(parted) q
```
You now have successfully created a DOS parition table on your drive. If you go into cfdisk check at the top if the 'Label' field indicates 'msdos'.

It is a good idea to create the SWAP parition as big as your installed RAM.
This enables the feature to [hibernate](https://en.wikipedia.org/wiki/Hibernation_(computing)) your Linux without running into problems.
Now create your partitions with cfdisk:
 ```
$ cfdisk
--> Create a 1GB partition of type 'Linux'
--> Create a 1GB partition of type 'EFI'
--> Create a X-GB partition of type 'SWAP'
--> Create a parition that fills out the rest and is of type 'Linux Filesystem'
--> Write to disk and exit
```

Now on to the drive encryption phase:
```
$ cryptsetup luksFormat /dev/yourLinuxFilesystem (Example: /dev/sda4)
$ cryptsetup luksOpen /dev/yourLinuxFilesystem someName
$ mkfs.fat -F 32 -n boot /dev/yourEfi (Example: /dev/sda2)
$ mkswap -L swap /dev/yourSwap (Example: /dev/sda3)
$ mkfs.ext4 -L nixos /dev/mapper/someName
$ mount /dev/mapper/someName /mnt
$ mkdir /mnt/boot
$ mount /dev/yourEfi /mnt/boot
$ nixos-generate-config --root /mnt
```
Your generated configurations now are at /mnt/etc/nixos.
Edit the configuration.nix and uncomment the following lines:
```
i18n = {
  consoleFont = "Lat2-Terminus16";
  consoleKeyMap = "de";
  defaultLocale = "en_US.UTF-8";
};
```
Change the 'consoleKeyMap' option to the keymap you set at the beginning. This is important or your password may be differently typed at bootup.


Now add the following lines to the configuration.nix:
```
boot.loader.grub.enable = true;
boot.loader.grub.version = 2;
boot.loader.grub.device = "yourDeviceWithoutNumber" (Example: '/dev/sda', NOT: '/dev/sda1')
```

Make sure to have internet access. If you don't have a LAN connection
configure WPA supplicant so we can use WIFI:
```
$ cat > /etc/wpa_supplicant.conf
network={
  ssid="****"
  psk="****"
}
$ systemctl start wpa_supplicant
```

Before copying your nixos configs over you want to be sure to be able to boot.
So install this minimal nix config with:

```
$ nixos-install
$ reboot
```

If you don't boot into your nixos go to the section 'Trouble Shooting'

## Trouble Shooting

If you boot into the nixos menu, great! If not reboot into your nix-usb stick and do the following:
```
$ loadkeys de --> Or whatever language your keyboard is
$ cryptsetup luksOpen /dev/yourLinuxFilesystem someName
$ mount /dev/mapper/someName /mnt
$ mount /dev/yourEfi /mnt/boot
```

Now you can edit the configurations at /mnt/etc/nixos. After editing them do:
```
$ nixos-install
```
Check for any error messages!! If no errors occurred execute:

```
$ reboot
```
And hope to boot into your nixos.


## After Installation

Now you can clone this repo and put it into /etc/nixos.
After cloning add the unstable channel of nixos. Not as a default channel though. This configuration uses 'hybrid' channels,
thus it uses selected packages from the unstable branch because often enough they are not accessible in stable.
To do this execute:
```
nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
```

## Randomly encrypted swap
A randomly encrypted swap is highly incouraged. You lose the hibernation feature but
gain an important security feature.

Display all partitions with their uuids
```
$ fdisk -l 

[...]
Device             Start       End   Sectors   Size Type
/dev/nvme0n1p1      2048   2099199   2097152     1G EFI System
/dev/nvme0n1p2   2099200 913858559 911759360 434.8G Linux filesystem
/dev/nvme0n1p3 913858560 976773119  62914560    30G Linux swap
```


Delete the swap signature from your swap partition.  
Make sure to select the correct parition because this is a destructive operation!
```
$ wipefs -a /dev/nvme0n1p3
```

Now edit /mnt/etc/hardware-configuration.nix and remove:
```
  swapDevices = [
    {
        device = "/dev/disk/by-uuid/<swap-uuid>";
    }
];
```

With `ls -la /dev/disk/by-partuuid` find the part-uuid of your swap partition.

Now edit your configuration.nix and add:
```
  swapDevices = [
    {
        device = "/dev/disk/by-partuuid/<part-swap-uuid>";
        randomEncryption = {
            enable = true;
        };
    }
    ];
```


## View configuration options locally
To view the possible configuration.nix options you can execute:
```
man configuration.nix
```
Or go to: [Nixos Options](https://nixos.org/nixos/options.html#)


### Aliases
Aliases are defined globally for every user in aliases.nix. To view your aliases configuration from the commandline just type 'aliases' which executes:
```
less /etc/nixos/aliases.nix
```

## Tearing / Display problems
This is probably a cause of incorrect xserver driver.  
In the `windows-manager.nix` file there is an option ` services.xserver.videoDriver`
change the driver to one your cpu or gpu supports.


### Screen Resizing
The tool used for auto resizing the resolution is autorandr.

Save your current xrandr display configuration with:
```
 $ autorandr --save mobile
```

Connect an additional display, configure your setup (with xrandr) and save it:
```
 $ autorandr --save docked
```

Now autorandr can detect which hardware setup is active:
```
$ autorandr
   mobile
   docked (detected)
```
Your changed configuration gets saved in:
```
/home/mainUser/.config/autorandr
```
Now copy your folder to /etc/nixos/configs/autorandr to make these changes persistent
```text
Another script called "postswitch" can be placed in the directory
~/.config/autorandr as well as in all profile directories: The scripts are executed
after a mode switch has taken place and can notify window managers or other
applications about it.
```

### Notifications
Dunst is used as notification system. To dismiss messages press:
```
strg + space
```
To create a shell script that sends notifications as another user use:
```
#!/bin/sh -e

SWAY_PID=$(ps -U $USER | grep sway-wrapped | awk '{ print $1  }')
DBUS_SESSION_BUS_ADDRESS=$(xargs -0 -L1 -a "/proc/$SWAY_PID/environ" | grep "DBUS_SESSION_BUS_ADDRESS=" | sed 's/DBUS_SESSION_BUS_ADDRESS=//')
export DBUS_SESSION_BUS_ADDRESS

notify-send "Screensaver" "Screensaver activates soon" #&> notify.strace

```



### Autorun

To activate programs on window-manager-start edit the i3 config in /etc/nixos/window-manager.nix and look out for lines with:
```
exec_always <command>
```

### Shortcuts Help
To find a list of shortcuts for i3 execute:
```
$ shortcuts-i3
```
To find a list of shortcuts for the terminal execute:
```
$ shortcuts-shell
```
To find a list of shortcuts for vim execute:
```
$ shortcuts-vim
```

### Start a project in nix
Execute following command in your project directory:
```
$ nixify
```
You will be dropped to a default default.nix configuration and after
writing and closing it will automatically drop you into a zsh shell with all dependencies.
This command creates following files.
```default.nix``` --> Has all the dependencies
```.envrc```      --> Is a bash file that get's loaded on directory entry

Has to be allowed through:
```
$ direnv allow .envrc
```

### Reset terminal layout
* F12   --> Spawns two gnome-shells in one separate container
* F11   --> Closes all gnome-shells and spawns them anew


### Learning the Nix language
* Nix challenges: https://nixcloud.io/tour/
* Nix pills: https://nixos.org/nixos/nix-pills/why-you-should-give-it-a-try.html


### Change Background
To change the background replace the file /etc/nixos/resources/wallpaper.png
And edit the config file in that directory if it has a different name


### Change look and feel of gnome applications
Gnome applications use dconf as key/value store to store its configuration.
The store is a binary file located at '~/.config/dconf/user'. To get a textual
representation use:
```
dconf dump / > config.key
```
To load your saved config use:
```
dconf load / < config.key
```
The nix file doing this is called: windows-manager.nix


### Set theme
Install your theme through nixpkgs and then use:
```
lxappearance
```
To switch to the desired configuration. The resulting config file is located at:  
'~/.config/gtk-3.0/settings.ini'
The content of this file should be added to theme.nix


### Assign Window To Specific Workspace
Execute:
```
$ xprop
```
* Click on your desired window. Locate a string that looks like the following:
```
WM_CLASS(STRING) = "gnome-terminal-server", "Gnome-terminal"
```
* Change the i3-config in /etc/nixos/configs/i3/config with the "assign" statesments in line 155. Change the class="" with the second argument of WM_CLASS(STRING)
in the example above it would be "Gnome-terminal"

### Set Own Keyshortcuts
Install the package 'xev' with and execute it:
```
$ nix-env -i xev
$ xev
```

Now hover over the white window in there you can press the key you want to bind.
In the console will appear the name of your key. Now edit the i3 config under /etc/nixos/configs/i3/config.
The console output should look something like this:
```
KeyRelease event, serial 33, synthetic NO, window 0x2600001,
    root 0x129, subw 0x0, time 12738207, (5,805), root:(1291,846),
    state 0x0, keycode 237 (keysym 0x1008ff06, XF86KbdBrightnessDown), same_screen YES,
    XLookupString gives 0 bytes:
    XFilterEvent returns: False
```

The key name to bind in this example would be the function key 'XF86KbdBrightnessDown'. Something like this could end up in the i3 config file:

```
bindsym XF86MonBrightnessDown exec --no-startup-id xbacklight -10
```

### Set Own Mouseshortcuts
Same as above but you have to specify the button number. Example xev output for a side button on my mouse:
```
ButtonRelease event, serial 33, synthetic NO, window 0x2600001,
    root 0x129, subw 0x0, time 12961067, (1,951), root:(1287,992),
    state 0x0, button 9, same_screen YES
```

The i3 config line would look something like this:
```
bindsym --whole-window button8 workspace prev
```

### Libvirtd
Download website: https://www.spice-space.org/download.html

To make propper window resizing possible in Windows, install following driver in the guest:\
https://www.spice-space.org/download/windows/spice-guest-tools/spice-guest-tools-latest.exe


For debian like systems run the following:
```
$ sudo apt install spice-vdagent
$ reboot
```

### Nix Shell Examples
Development nix-shell-examples can be found under shell-configs. To be able to use them rename it to shell.nix or default.nix and execute nix-shell while being in that directory

## Wifi Driver Installation Under Nixos
This one is a bit tricky. On the installation of nixos the pci enumeration will be handled and the hardware-configuration.nix gets changed accordingly. Sometimes you have to enable unfree pakages for this to work with 'nixpkgs.config.allowUnfree = true;'. If you miss this step you can look into the github file that does the enumeration at:\
https://github.com/NixOS/nixpkgs/blob/b15e884f80d15ceb56bcb9da6d2e11b75ea7d838/nixos/modules/installer/tools/nixos-generate-config.pl \
Instead of manually setting the options it is better to regenerate your hardware-configuration.nix. Be aware that this will override it:
```
nixos-generate-config
```

If nothing works for you. You can enable ALL firmware. Behold this could break things.
```
 hardware.enableAllFirmware = true;
 hardware.enableRedistributableFirmware = true;
```

## Decrypt Disks Via SSH
> DISCLAIMER: The private key will be available to all users because it will be copied to the nix store.
> This means that if a user gets his hands on the private key he can log on to the initramfs on bootup
> and can manipulate the bootup scripts. If you have a multiuser machine this is not recommended.

First you have to install the dropbear client and pciutils:
```
$ nix-env -i dropbear pciutils
```
You should add the module(s) required for your network card to 'boot.initrd.availableKernelModules'. Following command will tell you which driver to add:
```
$ lspci                                 --> Lists the pci devices attached to your mainboard
$ lspci -v -s <ethernet controller>     --> For example: lspci -v -s 00:1f.4
```

This is your private key:
```
$ dropbearkey -t rsa -f /etc/nixos/initrd-keys/dropbear_rsa
```

This is your public key:
```
$ dropbearkey -y -f /etc/nixos/initrd-keys/dropbear_rsa | grep "^ssh- >> /etc/nixos/initrd-keys/dropbear_rsa.pub
```

It is important to change the ssh port so that your known_hosts file has a way to differentiate between the two ssh entries and doesn't display a warning. \
NOTE: Do not specify a port above 100 this leads to some strange errors.
Now add the following to your configuration.nix and fill in the blanks:
```
# Enable decryption on boot per ssh
    boot.initrd.network.enable = true;
    boot.initrd.network.ssh.port = 23; # Add a port to your liking
    boot.initrd.network.ssh.enable = true;
    boot.initrd.network.ssh.authorizedKeys = [ "ssh-rsa [...] root@server" ]; # Add here your public key as string
    networking.useDHCP = true;
    boot.initrd.network.ssh.hostRSAKey = "/etc/nixos/initrd-keys/dropbear_rsa"; # Add here the path to your private key
    boot.initrd.availableKernelModules = [ "" ]; # Add here the driver for your network card
```

Now convert your private dropbear key to an openssh compatible one so that it works with the 'ssh' command.
```
$ dropbearconvert dropbear openssh /etc/nixos/initrd-keys/dropbear_rsa /etc/nixos/initrd-keys/dropbear_rsa_converted
```

After this is done copy the private key to your client. To connect to your server execute:
```
$ ssh -i dropbear_rsa_converted -p 23 root@192.168.1.[...]
```

On the server you now have an 'ash' shell. In there execute the following to decrypt your drives:
```
$ cryptsetup-askpass
```

## Share vim clipboard accross ssh session
To be albe to copy text to and from an ssh session in neovim you have to enable x11forwarding in trusted host mode and have xclip installed.
This should only be done if the server you are connecting to is operated only by you and is trusted because with x11 forwarding the server has capabillities to interact with your x11 session which can be quite dangerous.

* This is how your ssh_config should look like:
```
Host dev-vm
    Hostname 192.168.122.245
    User linus
    ForwardX11 yes
    ForwardX11Trusted yes
```
And now upload my nvim config located in configs/nvim/init.vim to the remote host. 
For a debian based system execute the following:
```
$ sudo apt-get install git exuberant-ctags ncurses-term curl golang-go pylint golint python3 python3-pip xclip
$ pip3 install --user --upgrade neovim
```

## Setup ZFS as root partition
Boot from your install ISO in memory.
Change the permissions of the /etc/nixos/configuration.nix to rwx. This is only temporary.
```
$ chmod 777 /etc/nixos/configuration.nix
```
Then add zfs support to the configuration. Enable unstable zfs for encryption support:
```
boot.supportedFilesystems = [ "zfs" ];
boot.zfs.enableUnstable = true;
```
And rebuild (you need internet access):
```
$ nixos-rebuild switch
```



Go to step EFI Install if you want an efi bootloader or go to BIOS Install if you want a Grub bootloader.  
Do not use LUKS encryption in these steps. ZFS has its own live encryption algorithm since nixos 18.03.  
Format the primary harddrive accordingly. Our primary harddrive now looks like this (with bios boot):  
```
/dev/sda1 --> 1GB Bios Boot (unformatted)
/dev/sda2 --> 1Gb Efi partition (fat32 formatted)
/dev/sda3 --> anything
```

List connected storages with:
```
$ parted -l
```

We are using /dev/disk/by-id/ instead of /dev/sda etc. because the latter isn't persistent accross HDD reordering.
Then execute the following:
```
$ zpool create -o ashift=12 rpool mirror /dev/disk/by-id/<drive>-part3 /dev/disk/by-id/<drive>
$ zfs create -o encryption=aes-128-gcm -o keyformat=passphrase -o mountpoint=none rpool/root
$ zfs create -o mountpoint=legacy rpool/root/nixos
```

Check if everything has been created accordingly:
```
$ zpool list
$ zfs list
```
Now mount the ZFS Dataset:
```
$ mount -t zfs rpool/root/nixos /mnt
```

Now do the normal installation steps:
```
$ mkdir /mnt/boot
$ mount /dev/sda2 /mnt/boot
$ nixos-generate-config --root /mnt
$ head -c 8 /etc/machine-id >> /mnt/etc/nixos/configuration.nix
```

Afterwards edit the /mnt/etc/nixos/configuration.nix and add following lines:
```
boot.supportedFilesystems = [ "zfs" ];
boot.loader.grub.devices = [ "/dev/disk/by-id/<drive>" ];
```
Cut the appended lastline in configuration.nix in your favorite editor and add it to following line:
```
networking.hostId = "4c614037";
```
And don't forget to change the locale:

```
i18n = {
  consoleFont = "Lat2-Terminus16";
  consoleKeyMap = "de";
  defaultLocale = "en_US.UTF-8";
};
```

Afterwards:
```
$ nixos-install
```

## APT-FILE
To find a missing dependencie you can do the following.
To build an index execute:
```
nix-index
```
To query the index:
```
nix-locate
```

## Install shell scripts lying around in nixpkgs
pkgs.writeScript "patchelf-hints" (lib.readFile <nixpkgs/maintainers/scripts/patchelf-hints.sh>)


## USBGuard
Only allows to enable usb devices defined in a rules.conf located in the secrets folder. See security.nix.
Generate a whitelist of connected devices with: ` $usbguard generate-policy `

## Rofi dmenu replacement
Spawned with WIN+d and cycle through modes with Ctrl+Tab
Window selector is called with WIN+x

## i3bar
Scrolling on the i3bar reduces or increases the volume. Right clicking on the i3bar mutes the volume.
Adding you own VPN interface name detection has to be done in the window-manager.nix in the `i3_status_script` field.


## Toggle keyboard backlight
To toggle the keyboard backlight execute `backlight-kbd` the definition is located in aliases.nix

## Git secrets
To prevent secrets/passwords to be commited to a git repository there is a tool called git secrets in place. To enable it in your git project execute:
```
$ git secrets --install
```
Now after every commit the repository gets scanned for forbidden strings with regex expressions. The blacklist can be seen with
```
$ git secrets --list
```
or under ./git.nix.
To add a whitelist rule to your local directory execute.
```
$ git secrets --add --allowed "example.{4}Password"
```
Note: Whitespaces can not be used in these rules, replace them with dots or equivalents.
Because the git-secrets module splits rules on whitespaces

To add a literal string without regex expressions / with automated quoting use:
```
$ git secrets --add --allowed --literal "example.{4}Password"
```
To add more blacklist rules edit the ./git.nix config. Don't forget, whitespaces are not allowed.

To view the locally whitelisted rules look into `.git/config`

## Posix Manpages
To look into the posix standarized manpages instead of the gnu ones use
`man p <keyword>`












