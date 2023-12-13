{ pkgs, config, lib, ... }:


{
  programs.command-not-found.enable = false;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions = {
      enable = true;
      strategy = [ "match_prev_cmd" "completion" "history"];
    };
    shellInit = ''
      zstyle ':completion:*' special-dirs true
 #     source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    '';

    ohMyZsh = {
      enable = true;
      theme = "gnzh";
      plugins = [
        "git"
      ];
    };

    interactiveShellInit = ''
    # direnv integration
    eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
  '';
  };

  users.defaultUserShell = pkgs.zsh;


  # For nix-direnv-flakes to work
  environment.pathsToLink = [
    "/share/nix-direnv"
  ];

  environment.systemPackages = with pkgs; [
    kitty
    xdg_utils # Tool to query system defaults
    direnv
  ];


  fonts.packages = with pkgs; [
    nerdfonts
  ];

  #environment.variables = {
  #  TERM = [ "kitty" ];
  #};
}
