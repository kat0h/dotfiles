#!/bin/bash
set -e -x

# for KDE
# jp106 keyboard

# TODO: 現在のfcitx5の設定を再度コピーする

sudo pacman -S --noconfirm --needed fcitx5-skk fcitx5-breeze fcitx5-configtool
# Fcitx should be launched by KWin under KDE Wayland in order to use Wayland input method frontend.
# This can improve the experience when using Fcitx on Wayland. To configure this, you need to go to
# "System Settings" -> "Virtual keyboard" and select "Fcitx 5" from it. You may also need to disable
# tools that launches input method, such as imsettings on Fedora, or im-config on Debian/Ubuntu.
# For more details see https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#KDE_Plasma

mkdir -p ~/.config/fcitx5/
[ -e ~/.config/fcitx5/profile ] || tee ~/.config/fcitx5/profile << CONF 
[Groups/0]
# Group Name
Name=Default
# Layout
Default Layout=jp
# Default Input Method
DefaultIM=skk

[Groups/0/Items/0]
# Name
Name=keyboard-jp
# Layout
Layout=

[Groups/0/Items/1]
# Name
Name=skk
# Layout
Layout=jp

[GroupOrder]
0=Default
CONF

RULEDIR="$HOME/.config/libskk/rules/myrule"
function setup_sticky_shift() {
  mkdir -p "$RULEDIR"
  tee "$RULEDIR"/metadata.json << METADATA
{
  "name": "my rule",
  "description": "sticky shift"
}
METADATA
  mkdir -p "$RULEDIR"/keymap
  tee "$RULEDIR"/keymap/hiragana.json << HIRAGANA
{
  "include": [
    "default/hiragana"
  ],
  "define": {
    "keymap": {
      ";": "start-preedit-no-delete"
    }
  }
}
HIRAGANA
  tee "$RULEDIR"/keymap/katakana.json << KATAKANA
{
  "include": [
    "default/katakana"
  ],
  "define": {
    "keymap": {
      ";": "start-preedit-no-delete"
    }
  }
}
KATAKANA
}
[ -d "$RULEDIR" ] || setup_sticky_shift

echo "please enable fcitx5 virtual keyboard"
