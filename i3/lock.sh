#!/bin/sh -e

# Take a screenshot
# scrot /tmp/screen_locked.png

# Pixellate it 10x
# mogrify -blur 15x7 /tmp/screen_locked.png

# Lock screen displaying this image.
i3lock --nofork -i $HOME/.wallpaper
