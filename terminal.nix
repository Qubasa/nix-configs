{pkgs, config, lib, ...}:

let

unstable = import <nixos-unstable> {};

# terminal.sexy tartan color scheme
# to create new default layout set your layout
# and press "save" under setttings->Profile->default
terminal_config = pkgs.writeText "config" ''
[global_config]
  borderless = True
  title_font = Monospace 16
  title_inactive_bg_color = "#555753"
  title_inactive_fg_color = "#dedede"
  title_transmit_bg_color = "#2e3436"
  title_transmit_fg_color = "#dedede"
  title_use_system_font = False
[keybindings]
[layouts]
  [[default]]
    [[[child0]]]
      fullscreen = False
      last_active_term = 969787e8-ea67-4ff9-8bd3-899b00644d9f
      last_active_window = True
      maximised = True
      order = 0
      parent = ""
      position = 0:0
      size = 1920, 1026
      title = man terminator_config
      type = Window
    [[[child1]]]
      order = 0
      parent = child0
      position = 957
      ratio = 0.499738903394
      type = HPaned
    [[[child2]]]
      order = 0
      parent = child1
      position = 511
      ratio = 0.500489715965
      type = VPaned
    [[[terminal3]]]
      order = 0
      parent = child2
      profile = default
      type = Terminal
      uuid = 969787e8-ea67-4ff9-8bd3-899b00644d9f
    [[[terminal4]]]
      order = 1
      parent = child2
      profile = default
      type = Terminal
      uuid = 998bc397-f4fb-4985-ae2e-2fcfa41dc68b
    [[[terminal5]]]
      order = 1
      parent = child1
      profile = default
      type = Terminal
      uuid = 51b057a9-233e-4b6a-88cf-4884b076fce7
[plugins]
[profiles]
  [[default]]
    allow_bold = False
    background_color = "#2b2b2b"
    copy_on_selection = True
    cursor_color = "#dedede"
    font = Monospace 16
    foreground_color = "#dedede"
    rewrap_on_resize = False
    scrollback_lines = 10000
    scrollbar_position = hidden
    show_titlebar = False
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
