{pkgs, config,  ...}:
{

  fonts = {
    # Find the name of your fonts
    # under /run/current-system/sw/share/X11-fonts
    enableFontDir = true;
    fonts = with pkgs; [
      font-awesome_5
    ];
    fontconfig = {
        enable = true;
        allowBitmaps = false;
        antialias = true;
        hinting.enable = false;
      };

  };



}
