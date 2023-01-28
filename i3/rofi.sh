theme="$HOME/dot-files/i3/rofi-theme.cfg"

rofi -show run -theme $theme --dpi $(xrdb -get Xft.dpi)
