{pkgs, config, lib, ...}:

let

unstable = import <nixos-unstable> {};

# terminal.sexy tartan color scheme
terminal_config = pkgs.writeText "config" ''
[global_config]
  borderless = True
  title_font = Monospace 18
  title_inactive_bg_color = "#555753"
  title_inactive_fg_color = "#dedede"
  title_transmit_bg_color = "#2e3436"
  title_transmit_fg_color = "#dedede"
  title_use_system_font = False
[keybindings]
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      profile = default
      type = Terminal
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    allow_bold = False
    background_color = "#2b2b2b"
    copy_on_selection = True
    cursor_color = "#dedede"
    font = Monospace 18
    foreground_color = "#dedede"
    rewrap_on_resize = False
    scrollback_lines = 10000
    scrollbar_position = hidden
    use_system_font = False
  '';

in {

  environment.systemPackages = with pkgs; [
    terminator
  ];

  environment.variables = {
    TERM = [ "xterm-256color" ];
  };

  system.activationScripts.copyTermiteConfig = ''
      mkdir -p ${config.mainUserHome}/.config/terminator
      ln -f -s ${terminal_config} ${config.mainUserHome}/.config/terminator/config
      chown -R ${config.mainUser}: ${config.mainUserHome}/.config/terminator
  '';
}
