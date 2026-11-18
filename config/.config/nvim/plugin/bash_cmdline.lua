-- The command-line buffer opened by bash's C-x C-e (see
-- ~/.config/bash/inline-edit.bash, which names the file bash-cmdline.*.bash):
--   * starts in insert mode after the last character
--   * <Esc> in normal mode saves and quits
--   * bash's own Tab completion (bash-completion, ~/.bashrc) as a blink.cmp source
--
-- Self-contained: delete this file to turn it all off.

-- Completion server: a bash that loads the same completions as an
-- interactive shell and answers requests on stdin.
-- Request (one line, fields separated by \x1f, ending with an "END" field):
--   COMP_CWORD, COMP_LINE, COMP_POINT, COMP_WORDS...
-- Reply: one line of `-o` options, the candidates one per line, then \x1e.
local SERVER = [==[
{ [[ -r ~/.bashrc ]] && source ~/.bashrc; } </dev/null >/dev/null 2>&1
if ! declare -F _comp_load >/dev/null; then
  source /usr/share/bash-completion/bash_completion </dev/null >/dev/null 2>&1
fi
shopt -s extglob progcomp
set +o history

# compopt only works inside a real completion; record what is asked for.
compopt() {
  while (($#)); do
    case $1 in
      -o) __opts+=" $2"; shift 2 ;;
      +o) __opts=${__opts// $2/}; shift 2 ;;
      *) shift ;;
    esac
  done
}

__complete() {
  local cmd=${COMP_WORDS[0]} cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
  COMPREPLY=()
  if ((COMP_CWORD == 0)); then
    mapfile -t COMPREPLY < <(compgen -c -- "$cur" | sort -u)
    return
  fi
  local spec
  spec=$(complete -p -- "$cmd" 2>/dev/null) ||
    { _comp_load -- "$cmd" >/dev/null 2>&1; spec=$(complete -p -- "$cmd" 2>/dev/null); } ||
    spec=$(complete -p -D 2>/dev/null) ||
    spec="complete -o default x"
  local -a sa args=()
  eval "sa=($spec)"
  local i=1 func=
  while ((i < ${#sa[@]} - 1)); do
    case ${sa[i]} in
      -o) __opts+=" ${sa[i+1]}"; args+=(-o "${sa[i+1]}"); ((i += 2)) ;;
      -F) func=${sa[i+1]}; ((i += 2)) ;;
      -[ACGWXPS]) args+=("${sa[i]}" "${sa[i+1]}"); ((i += 2)) ;;
      -D|-E|-I) ((i++)) ;;
      *) args+=("${sa[i]}"); ((i++)) ;;
    esac
  done
  if [[ -n $func ]]; then
    "$func" "$cmd" "$cur" "$prev" </dev/null >/dev/null 2>&1
  fi
  if ((${#args[@]})); then
    mapfile -t -O "${#COMPREPLY[@]}" COMPREPLY < <(compgen "${args[@]}" -- "$cur" 2>/dev/null)
  fi
  if ((${#COMPREPLY[@]} == 0)) && [[ $__opts == *default* ]]; then
    __opts+=" filenames"
    mapfile -t COMPREPLY < <(compgen -f -- "$cur" 2>/dev/null)
  fi
}

while IFS= read -r __req; do
  IFS=$'\x1f' read -ra __f <<<"$__req"
  COMP_CWORD=${__f[0]} COMP_LINE=${__f[1]} COMP_POINT=${__f[2]}
  COMP_WORDS=("${__f[@]:3:${#__f[@]}-4}")
  COMP_TYPE=9 COMP_KEY=9
  __opts=
  __complete
  printf '%s\n' "$__opts"
  printf '%s\n' "${COMPREPLY[@]}"
  printf '\x1e\n'
done
]==]

local server = { job = nil, buf = "", queue = {} }

local function server_start()
  if server.job then
    return true
  end
  local job = vim.fn.jobstart({ "bash", "--noprofile", "--norc", "-c", SERVER }, {
    cwd = vim.fn.getcwd(),
    on_stdout = function(_, data)
      -- data is a list of lines; the first continues the last partial line.
      server.buf = server.buf .. table.concat(data, "\n")
      while true do
        local s, e = server.buf:find("\30\n", 1, true)
        if not s then
          break
        end
        local reply = server.buf:sub(1, s - 1)
        server.buf = server.buf:sub(e + 1)
        local cb = table.remove(server.queue, 1)
        if cb then
          cb(reply)
        end
      end
    end,
    on_exit = function()
      server.job = nil
      server.buf = ""
      for _, cb in ipairs(server.queue) do
        cb(nil)
      end
      server.queue = {}
    end,
  })
  if job <= 0 then
    return false
  end
  server.job = job
  return true
end

local function server_request(fields, cb)
  if not server_start() then
    return cb(nil)
  end
  table.insert(server.queue, cb)
  table.insert(fields, "END")
  vim.fn.chansend(server.job, table.concat(fields, "\31") .. "\n")
end

-- Split the command being typed (up to the cursor) into words the way bash
-- does for COMP_WORDS. Returns the words and the byte offset in `text` where
-- the word readline would replace starts.
local BREAKS = "=:<>"
local SEPARATORS = "|;&()"
local function split_words(text)
  -- Start of the current simple command: after the last unquoted separator.
  local quote, esc, start = nil, false, 1
  for i = 1, #text do
    local c = text:sub(i, i)
    if esc then
      esc = false
    elseif c == "\\" and quote ~= "'" then
      esc = true
    elseif quote then
      if c == quote then
        quote = nil
      end
    elseif c == "'" or c == '"' then
      quote = c
    elseif SEPARATORS:find(c, 1, true) then
      start = i + 1
    end
  end

  local words, cur, replace_from = {}, nil, start
  quote, esc = nil, false
  local function flush()
    if cur then
      table.insert(words, cur)
      cur = nil
    end
  end
  for i = start, #text do
    local c = text:sub(i, i)
    if esc then
      esc = false
      cur = (cur or "") .. c
    elseif c == "\\" and quote ~= "'" then
      esc = true
      cur = (cur or "") .. c
    elseif quote then
      cur = cur .. c
      if c == quote then
        quote = nil
      end
    elseif c == "'" or c == '"' then
      quote = c
      cur = (cur or "") .. c
      replace_from = i + 1
    elseif c:match("%s") then
      flush()
      replace_from = i + 1
    elseif BREAKS:find(c, 1, true) then
      -- A run of break characters is a word of its own.
      if not (cur and BREAKS:find(cur:sub(-1), 1, true)) then
        flush()
      end
      cur = (cur or "") .. c
      replace_from = i + 1
    else
      if cur and BREAKS:find(cur:sub(-1), 1, true) then
        flush()
      end
      cur = (cur or "") .. c
    end
  end
  if cur then
    table.insert(words, cur)
  else
    table.insert(words, "")
  end
  return words, replace_from - 1, start
end

local function escape_filename(s)
  local home = s:match("^~[^/]*")
  local rest = s:sub(#(home or "") + 1)
  return (home or "") .. rest:gsub("([%s\"'`$&|;<>()\\!*?{}%[%]#])", "\\%1")
end

local Source = {}
Source.__index = Source

function Source.new()
  return setmetatable({}, Source)
end

function Source:enabled()
  return vim.b.bash_cmdline == true
end

function Source:get_completions(ctx, callback)
  local row, col = ctx.cursor[1], ctx.cursor[2]
  local text = ctx.line:sub(1, col)
  local words, replace_from, cmd_start = split_words(text)
  local comp_line = text:sub(cmd_start):gsub("^%s+", "")
  local fields = { tostring(#words - 1), comp_line, tostring(#comp_line) }
  vim.list_extend(fields, words)

  server_request(fields, function(reply)
    if not reply then
      return callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = true })
    end
    local lines = vim.split(reply, "\n", { plain = true })
    local opts = " " .. (table.remove(lines, 1) or "") .. " "
    local filenames = opts:find(" filenames ", 1, true) ~= nil
    local nospace = opts:find(" nospace ", 1, true) ~= nil
    local items, seen = {}, {}
    local kinds = require("blink.cmp.types").CompletionItemKind
    for _, cand in ipairs(lines) do
      if cand ~= "" and not seen[cand] then
        seen[cand] = true
        local label = cand:gsub("%s+$", "")
        local insert, kind = cand, kinds.Value
        if filenames then
          local is_dir = vim.fn.isdirectory(vim.fn.expand(label)) == 1
          insert = escape_filename(label) .. (is_dir and "/" or (nospace and "" or " "))
          kind = is_dir and kinds.Folder or kinds.File
          label = is_dir and label .. "/" or label
        elseif cand == label and not nospace then
          insert = cand .. " "
        end
        table.insert(items, {
          label = label,
          kind = kind,
          filterText = label,
          textEdit = {
            newText = insert,
            range = {
              start = { line = row - 1, character = replace_from },
              ["end"] = { line = row - 1, character = col },
            },
          },
        })
      end
    end
    callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = true })
  end)
end

package.loaded["bash_cmdline_source"] = Source

local registered = false
local function register_source()
  if registered then
    return
  end
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then
    return
  end
  registered = true
  blink.add_source_provider("bash_cmdline", {
    name = "bash",
    module = "bash_cmdline_source",
    score_offset = 10,
  })
  blink.add_filetype_source("sh", "bash_cmdline")
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("bash_cmdline", { clear = true }),
  pattern = "bash-cmdline.*.bash",
  callback = function(ev)
    vim.b[ev.buf].bash_cmdline = true
    vim.keymap.set("n", "<Esc>", "<cmd>:wq<cr>", { buffer = ev.buf, desc = "Save and return to bash" })
    register_source()
    server_start()
    -- Start in insert mode after the last character.
    vim.schedule(function()
      if vim.api.nvim_get_current_buf() == ev.buf then
        vim.api.nvim_win_set_cursor(0, { vim.api.nvim_buf_line_count(ev.buf), 0 })
        vim.cmd("startinsert!")
      end
    end)
  end,
})
