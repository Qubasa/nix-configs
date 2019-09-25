{pkgs, config, lib, ...}:

{

    environment.systemPackages = with pkgs; [
      tmux
    ];

    programs.tmux.enable = true;

    programs.tmux.extraTmuxConf = ''

# 0 is too far from ` ;)
set -g base-index 1

# Automatically set window title
set-window-option -g automatic-rename on
set-option -g set-titles on

#set -g default-terminal screen-256color
set -g status-keys vi
set -g history-limit 10000

setw -g mode-keys vi
setw -g mouse on
setw -g monitor-activity on

bind-key v split-window -h
bind-key h split-window -v



# Use Alt-arrow keys without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Shift arrow to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# No delay for escape key press
set -sg escape-time 0

# zoom this pane to full screen
bind + \
    new-window -d -n tmux-zoom 'clear && echo TMUX ZOOM && read' \;\
    swap-pane -s tmux-zoom.0 \;\
    select-window -t tmux-zoom
# restore this pane
bind - \
    last-window \;\
    swap-pane -s tmux-zoom.0 \;\
    kill-window -t tmux-zoom

# move status line to top
set -g status-position top
bind m \
    set -g mouse \;\
    display 'Mouse toggled'

# THEME
set -g status-bg black
set -g status-fg white
set -g window-status-current-bg white
set -g window-status-current-fg black
set -g window-status-current-attr bold
set -g status-interval 60
set -g status-left-length 30
set -g status-left '#[fg=green](#S) #(whoami) '
set -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg)#[default] #[fg=white]%H:%M#[default]'
      '';
}
