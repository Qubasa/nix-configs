{pkgs, config, lib, ...}:

let


  # Color template is Tartan
  termite_config = pkgs.writeText "config" ''
    [options]
    font = Bitstream Vera Sans Mono 13

    [colors]

    # special
    foreground      = #dedede
    foreground_bold = #dedede
    cursor          = #dedede
    background      = #2b2b2b

    # black
    color0  = #2e3436
    color8  = #555753

    # red
    color1  = #cc0000
    color9  = #ef2929

    # green
    color2  = #4e9a06
    color10 = #8ae234

    # yellow
    color3  = #c4a000
    color11 = #fce94f

    # blue
    color4  = #3465a4
    color12 = #729fcf

    # magenta
    color5  = #75507b
    color13 = #ad7fa8

    # cyan
    color6  = #06989a
    color14 = #34e2e2

    # white
    color7  = #d3d7cf
    color15 = #eeeeec
  '';

in {

  environment.systemPackages = with pkgs; [
    termite
  ];

  environment.variables = {
    TERMINAL = [ "xterm-256color" ];
  };

  system.activationScripts.copyTermiteConfig = ''
      mkdir -p ${config.mainUserHome}/.config/termite
      ln -f -s ${termite_config} ${config.mainUserHome}/.config/termite/config
      chown -R ${config.mainUser}: ${config.mainUserHome}/.config/termite
  '';
}
