#!/usr/bin/env bash

# tmux start-server                                                     # start server, if not already running

# start new session and split resulting window into 2 panes
tmux new-session -d -s dev -n main \; \
  send-keys 'cd ~' C-m \; \
  split-window -h \; \
  send-keys 'cd ~' C-m \;

# split window into 2 panes horizontally
tmux new-window -t dev:1 -n filex \; \
  send-keys 'cd ~' C-m \; \
  split-window -h \; \
  send-keys 'cd ~' C-m \;

# split window into 3 panes similar sized panes vertically
tmux new-window -t dev:2 \; \
  send-keys 'cd ~' C-m \; \
  split-window -v -p 66 \; \
  split-window -v \;

# attach to session on window 0
tmux select-window -t dev:0
tmux attach-session -t dev

# tmux kill-server                                                      # ensure server is dead
