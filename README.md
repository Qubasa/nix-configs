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

# Error nixos-unstable channel not found
If this error occurs when you do a `nixos-install` then
execute instead:
```
$ nixos-install -I nixos-unstable=channel:nixos-unstable
```


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

## Getting building environment of a package
```
nix-shell '<nixpkgs>' -A hello
```
or the building environment for a x86 package
```
nix-shell '<nixpkgs>' -A pkgsi686Linux.hello
```


