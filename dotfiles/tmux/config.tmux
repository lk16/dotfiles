# scrollback size
set -g history-limit 100000

# reload with r
bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"

# pass through xterm keys
set -g xterm-keys on

# make sure status bar does not get cut off
set -g status-right-length 200

# tell tmux to update the statusbar every second
set -g status-interval 1

# open new panes in same directory
bind c new-window -c "#{$HOME}"
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# tweak status bar
set -g status-right '#(cd "$(dirname "$(readlink -f ~/.tmux.conf)")" && ./statusbar.sh)'

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'tmux-plugins/tmux-resurrect'

set -g @continuum-restore 'on'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'

# Use C-b C-s to save pane log to file in home folder
bind-key C-s run-shell 'tmux capture-pane -S - -E - -p > ~/tmux-output-$(date +%s).txt'
