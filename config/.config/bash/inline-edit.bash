# C-x C-e: edit the command line in nvim drawn inline below the prompt
# (needs inline-pty: https://github.com/kat0h/inline-pty).
# :wq puts the edited text back on the prompt without running it; :cq keeps
# the original line.
if command -v inline-pty >/dev/null; then
  _inline_edit_command_line() {
    local f editor
    read -ra editor <<<"${VISUAL:-${EDITOR:-nvim}}"
    f=$(mktemp -t bash-cmdline.XXXXXX --suffix=.bash) || return
    printf '%s\n' "$READLINE_LINE" >"$f"
    # bash erases the prompt line before running a `bind -x` command; draw it
    # again (clipped to one row) so it stays visible above the editor.
    local prompt=${PS1@P}
    prompt=${prompt//[$'\001\002']/}
    # The cursor is left where readline's cursor is, so the speech bubble's tail
    # points at it.
    local before=${READLINE_LINE:0:READLINE_POINT} after=${READLINE_LINE:READLINE_POINT}
    printf '\e[?7l%s%s\e7%s\e8\e[?7h' "$prompt" "${before//$'\n'/ ⏎ }" "${after//$'\n'/ ⏎ }" >/dev/tty
    if inline-pty --border -- "${editor[@]}" "$f" </dev/tty >/dev/tty; then
      READLINE_LINE=$(<"$f")
      READLINE_POINT=${#READLINE_LINE}
    fi
    rm -f "$f"
    printf '\r' >/dev/tty
  }
  # Run the function, then make readline redraw the line from scratch (it
  # would otherwise skip rows it thinks are unchanged).
  bind -x '"\e[9100~": _inline_edit_command_line'
  bind '"\e[9101~": redraw-current-line'
  bind '"\C-x\C-e": "\e[9100~\e[9101~"'
fi
