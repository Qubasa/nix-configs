{ pkgs, config, lib, ... }:
with lib;
let
  unstable = import <nixos-unstable> { };
in
{

  # Auto upgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "0/2:00:00"; # Check every 2 hours for updates

  # Check for updates 5 minutes after restart
  # systemd.timers."nixos-upgrade".timerConfig = {
  #   OnBootSec="5min";
  # };

  hardware.bluetooth.enable = false;

  security.polkit.enable = true;

  # Set sudo timeout to 30 mins
  security.sudo = {
    enable = true;
    extraConfig = "Defaults        env_reset,timestamp_timeout=30";
  };

  # List of users/@groups that are allowed to connect to the Nix daemon
  nix.allowedUsers = ["${config.mainUser}"];


  # Only allow specific usb devices
  services.usbguard.enable = true;
  services.usbguard.IPCAllowedUsers = [ "root" config.mainUser ];
  services.usbguard.ruleFile = "${config.secrets}/usbguard/rules.conf";

  systemd.user.services.usbguard-applet = {
    description = "USBGuard applet";
    partOf = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    path = [ "/run/current-system/sw/" ]; ### Fix empty PATH to find qt plugins
    serviceConfig = {
      ExecStart = "${pkgs.usbguard}/bin/usbguard-applet-qt";
      Restart = "always";
    };
  };

  # https://www.kuketz-blog.de/firejail-linux-haerten-teil4/
  programs.firejail.enable = true;
  programs.firejail.wrappedBinaries = {

    jailed_firefox = "--private-home=~/.mozilla ${pkgs.firefox}/bin/firefox";
    jailed_thunderbird = "--private-home=~/.thunderbird ${pkgs.thunderbird}/bin/thunderbird";
  };

  # Check if secrets are all non world readable
  system.activationScripts."check-permissions" = ''
    FOUND=$(find ${config.secrets} -type f -and ! -user root -or -type f -and ! -group root -or -type f -and -perm /o+r+w)
    if [ "$FOUND" != "" ]; then
      echo -e "\e[31mERROR: These files $FOUND \nare world readable / writeable!\e[39m"
    fi
    '';

  # Option for less to run in secure mode
  environment.variables = {
    LESSSECURE = [ "1" ];
  };

  boot.blacklistedKernelModules = [
  # Obscure network protocols
  "ax25"
  "netrom"
  "rose"
  ];

  # Breaks NetworkManager. Disable kernel module loading once the system is fully initialised.
  # security.lockKernelModules = true;

    boot.kernelParams = [
      # Slab/slub (F) sanity checks, (Z) redzoning, and (P) poisoning
      # Source: https://tails.boum.org/contribute/design/kernel_hardening/
    "slub_debug=ZP"

      # Disable slab merging to make certain heap overflow attacks harder
    "slab_nomerge"

    # Disable legacy virtual syscalls. Can break very old software. Highly effective against exploits.
    "vsyscall=none"

    # Enable Page Table Isolation even if CPU claims to be safe from meltdown
    # http://www.brendangregg.com/blog/2018-02-09/kpti-kaiser-meltdown-performance.html
    "pti=on"

     # Against Row-Hammer attack
     # will cause the kernel to panic on any uncorrectable ECC errors detected
     "mce=0"
    ];

  # Restrict process information to the owning user.
  security.hideProcessInformation = true;

  # Restrict ptrace() usage to processes with a pre-defined relationship
  # (e.g., parent/child)
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = mkOverride 500 1;

  # Restrict access to kernel ring buffer (dmesg) (information leaks)
  # Important!
  boot.kernel.sysctl."kernel.dmesg_restrict" = mkDefault true;


  # Hide kptrs even for processes with CAP_SYSLOG
  # Source: http://bits-please.blogspot.com/2015/08/effectively-bypassing-kptrrestrict-on.html
  boot.kernel.sysctl."kernel.kptr_restrict" = mkOverride 500 2;

  # Unprivileged access to bpf() has been used for privilege escalation in
  # the past
  boot.kernel.sysctl."kernel.unprivileged_bpf_disabled" = mkDefault true;

  # Disable bpf() JIT (to eliminate spray attacks)
  boot.kernel.sysctl."net.core.bpf_jit_enable" = mkDefault false;

  # ... or at least apply some hardening to it
  boot.kernel.sysctl."net.core.bpf_jit_harden" = mkDefault true;

  # Raise ASLR entropy for 64bit & 32bit, respectively.
  #
  # Note: mmap_rnd_compat_bits may not exist on 64bit.
  boot.kernel.sysctl."vm.mmap_rnd_bits" = mkDefault 32;
  boot.kernel.sysctl."vm.mmap_rnd_compat_bits" = mkDefault 16;

  # Allowing users to mmap() memory starting at virtual address 0 can turn a
  # NULL dereference bug in the kernel into code execution with elevated
  # privilege.  Mitigate by enforcing a minimum base addr beyond the NULL memory
  # space.  This breaks applications that require mapping the 0 page, such as
  # dosemu or running 16bit applications under wine.  It also breaks older
  # versions of qemu.
  #
  # The value is taken from the KSPP recommendations (Debian uses 4096).
  boot.kernel.sysctl."vm.mmap_min_addr" = mkDefault 65536;

}
