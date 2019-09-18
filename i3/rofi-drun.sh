bg_color=#2f343f
text_color=#f3f4f5
htext_color=#9575cd

rofi -show drun -lines 3 -eh 2 -width 100 -padding 800 -opacity "85" -bw 0 -color-window "$bg_color, $bg_color, $bg_color" -color-normal "$bg_color, $text_color, $bg_color, $bg_color, $htext_color" -font "System San Francisco Display 18"
