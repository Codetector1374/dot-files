theme="$HOME/dot-files/i3/rofi-theme.cfg"

rofi -show drun -theme $theme -show-icons -dpi $(xrdb -get Xft.dpi)
