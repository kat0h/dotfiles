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
[ -e ~/.config/fcitx5/profile ] || tee ~/.config/fcitx5/profile << PROF
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

PROF
[ -e ~/.config/fcitx5/config ] || tee ~/.config/fcitx5/config << CONF
[Hotkey]
# Enumerate when holding modifier of Toggle key
EnumerateWithTriggerKeys=True
# Temporarily Toggle Input Method
AltTriggerKeys=
# Enumerate Input Method Forward
EnumerateForwardKeys=
# Enumerate Input Method Backward
EnumerateBackwardKeys=
# Skip first input method while enumerating
EnumerateSkipFirst=False
# Time limit in milliseconds for triggering modifier key shortcuts
ModifierOnlyKeyTimeout=250

[Hotkey/TriggerKeys]
0=Control+space
1=Zenkaku_Hankaku
2=Hangul

[Hotkey/ActivateKeys]
0=Henkan

[Hotkey/DeactivateKeys]
0=Muhenkan

[Hotkey/EnumerateGroupForwardKeys]
0=Super+space

[Hotkey/EnumerateGroupBackwardKeys]
0=Shift+Super+space

[Hotkey/PrevPage]
0=Up

[Hotkey/NextPage]
0=Down

[Hotkey/PrevCandidate]
0=Shift+Tab

[Hotkey/NextCandidate]
0=Tab

[Hotkey/TogglePreedit]
0=Control+Alt+P

[Behavior]
# Active By Default
ActiveByDefault=False
# Reset state on Focus In
resetStateWhenFocusIn=Program
# Share Input State
ShareInputState=All
# Show preedit in application
PreeditEnabledByDefault=True
# Show Input Method Information when switch input method
ShowInputMethodInformation=True
# Show Input Method Information when changing focus
showInputMethodInformationWhenFocusIn=False
# Show compact input method information
CompactInputMethodInformation=True
# Show first input method information
ShowFirstInputMethodInformation=True
# Default page size
DefaultPageSize=5
# Override XKB Option
OverrideXkbOption=False
# Custom XKB Option
CustomXkbOption=
# Force Enabled Addons
EnabledAddons=
# Force Disabled Addons
DisabledAddons=
# Preload input method to be used by default
PreloadInputMethod=True
# Allow input method in the password field
AllowInputMethodForPassword=False
# Show preedit text when typing password
ShowPreeditForPassword=False
# Interval of saving user data in minutes
AutoSavePeriod=30
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
      ";": "start-preedit-no-delete",
      "l": null,
      "\\": null
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
      ";": "start-preedit-no-delete",
      "l": null,
      "\\\\": null
    }
  }
}
KATAKANA
}
[ -d "$RULEDIR" ] || setup_sticky_shift

echo "please enable fcitx5 virtual keyboard"
