export XDG_DATA_DIRS="/usr/local/share:/usr/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:${XDG_DATA_DIRS}"
xrandr --output HDMI-1-0 --primary --auto --above eDP-1 --output eDP-1 --auto
exec dwm
