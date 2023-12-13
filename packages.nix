{ config, pkgs, lib, ... }:

{

  programs.wireshark.enable = true;
  programs.bcc.enable = true; # bpf compiler collection
  services.sysprof.enable = true; # gnome profiler
  programs.sysdig.enable = true; # system call debugger
  services.gnome.tracker.enable = true; # file indexer
  services.gnome.tracker-miners.enable = true; # file indexer
  services.flatpak.enable = true;

  # sudo sysdig --list-chisels
  # sysdig -c echo_fds --> get everything written to a fd
  # sysdig -c stderr --> get all stderr from all processes
  # sysdig -c echo_fds proc.pid=732271 --> filter by process id

  nixpkgs.config.permittedInsecurePackages = [
        "electron-24.8.6"
  ];

  environment.systemPackages =

    # My modified nixpkgs
    (with pkgs.luis.pkgs; [
      #python39Packages.compdb # To get header files into compile_commands.json
    ])
    # Import packages from NUR repository
    # Package search: https://nur.nix-community.org/repos/mic92/
    ++ (with pkgs.nur.repos.mic92; [

    ])
    # Import from master branch
    ++ (with pkgs.master.pkgs; [
      signal-desktop
    ])
    # Import from unstable branch
    ++ (with pkgs.unstable.pkgs; [
      curtail # photo compression gui
      nixd
    ])
    ++ (with pkgs; [
      # bash basics
      man-pages
      posix_man_pages # Use the posix standarized manpages with `man p <keyword>`
      file
      wget
      git
      #curl-impersonate-bin      
      tree # display files as tree
      pstree # display processes as tree
      pwgen # generates passwords
      entr # Runs command if files changed
      jq # Json parsing in shell
      cifs-utils # Samba mount
      sshfs # Mount a filesystem through ssh
      unzip

      # Rust Shell Replacements
      #exa # ls in better
      zoxide # smart cd
      fd # find replacement
      ripgrep # grep replacement

      zellij # tmux alternative
      bat # Cat with syntax highlighting



      cht-sh # cheat sheet for commands
      tldr # short examples of commands
      btop # htop in better
      calc # Simple calculator
      fzf # fuzzy finder
      git-lfs # big files in git dirs
      gdu # fast disk usage displayer
      kondo # Save disk space by cleaning unneeded files

      # Nixos specific
      nixpkgs-fmt # format .nix files
      nixos-generators # Generate nixos images
      patchelf
      niv # NixOS project creator
      nix-prefetch # Sha256sum a link for nixos
      nix-index # apt-file equivalent
      nixpkgs-review # For reviewing pull requests
      pkgs.unstable.pkgs.nix-direnv-flakes
      direnv
      nix-doc # https://github.com/lf-/nix-doc
      cntr # linux container debugger
      exiftool # metadata viewer
      bitwise # bit calc / viewer
      imagemagick
      jellyfin-media-player
      diffoscope # Diffing tool for many file types
      # bear # Intercept make commands and generates compile_commands.json
      gnome.gnome-tweaks # Gnome settings
      binutils # Binary inspection
      radare2 # Binary reversing
      ghidra # Binary reversing
      powertop # A power saving tool
      dos2unix # Convert win newlines to unix ones
      rr # reverse execute and debug elfs
      libreoffice # Opening docs
      gimp # Editing pictures
      pavucontrol # audio device switcher per programm!
      sqlite-interactive # Sqlite cli
      tmate # remote shared terminal
      linuxPackages.perf # profiling utilities
      sysprof # gnome profiler UI
      docker-compose # docker helper tool
      mitmproxy # Great to debug https traffic
      picocom # good uart reader
      mumble # Voice chat
      remmina # Remote Desktop application
      tig # console gui for git
      ventoy-full # bootable usb creator
      gnupg # Email encryption
      okular # Pdf reader with bookmarks
      pika-backup # Backup tool UI
      calibre # ebook-convert
      helix # vim replacement
      git-absorb # git rebase helper

      audacity # Audio editor

      thunderbird # email client
      obs-studio # Screen recording
      texlive.combined.scheme-full # latex
      python39Packages.pygments # latex dep for syntax highlighting
      inkscape # latex dependencie for svg
      act # Execute github actions locally
      gdb # debugger
      elfutils # elf utilities
      usbutils
      dfeet # dbus explorer
      gnome.dconf-editor # gnome settings editor
      pdfarranger # pdf editor
      bitwarden # password manager
      bitwarden-cli
      ffmpeg-full # Convert video formats
      vlc # video player
      olive-editor # video editor
      gnome-builder # gtk ides
      flatpak-builder # gnome-builder dep
      glade # gtk IDE
      gnucash # accounting
      nix-init


      pandoc # convert between formats
      obsidian # note taking

      # hardware inspections
      pciutils
      smartmontools # ssd health check
      gnome-firmware # firmware updater

      # Network debugging
      dropwatch # watch for dropped packets
      networkmanagerapplet
      sipcalc # Calculates network masks from interfaces
      nmap # Network discovery
      traceroute # Network discovery cli
      tcpdump # TCP packet sniffer cli
      wireshark # Packet sniffer UI
      qtwirediff # Wireshark diff tool
      netcat-openbsd # nc tool
      tunctl # to create tap devices
      bridge-utils # to create bridges
      ldns # DNS tool 'drill'

    ]);


}
