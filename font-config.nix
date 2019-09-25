{pkgs, config,  ...}:
{

  fonts = {
    # Find the name of your fonts
    # under /run/current-system/sw/share/X11-fonts
    enableFontDir = true;
    fonts = with pkgs; [
      font-awesome_5
      ttf_bitstream_vera
    ];
    fontconfig = {
        enable = true;
        allowBitmaps = false;
        ultimate.enable = true;

        defaultFonts = {
          monospace = [ "Bitstream Vera Sans Mono" ];
        };
      };

  };



}
