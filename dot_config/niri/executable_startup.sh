# polkit
/usr/lib/polkit-kde-authentication-agent-1 &

# bg and idle daemon
swaybg -m fill -i ~/Dropbox/Images/wallpaper/wallpaper$(echo {0,1,2}|xargs -n1|shuf|head -1).jpg &
swayidle -w timeout 500 'niri msg action spawn -- hyprlock' \
            timeout 800 'sleep.sh' \
            before-sleep 'pactl set-sink-mute @DEFAULT_SINK@ true; niri msg action spawn -- hyprlock' &

# status bar
waybar -c /home/kat0h/.config/waybar/niri.jsonc &
nm-applet &
blueman-applet &
dropbox &
fcitx5 -d &

# clipboard
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

exec systemctl --user set-environment XDG_CURRENT_DESKTOP=niri
exec systemctl --user import-environment DISPLAY \
                                         SWAYSOCK \
                                         WAYLAND_DISPLAY \
                                         XDG_CURRENT_DESKTOP

exec hash dbus-update-activation-environment 2>/dev/null && \
     dbus-update-activation-environment --systemd DISPLAY \
                                                  XDG_CURRENT_DESKTOP=niri \
                                                  WAYLAND_DISPLAY

