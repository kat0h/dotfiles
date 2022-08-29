-- scrollbar
local colors = require("tokyonight.colors").setup()
require("scrollbar").setup{
  show_in_active_only = true,
  handle = {
    color = "#3b4261",
  },
  marks = {
    Search = {
      text = { "-", "=" },
      priority = 0,
      color = colors.orange,
    },
    Error = {
      text = { "-", "=" },
      priority = 1,
      color = colors.error,
    },
    Warn = {
      text = { "-", "=" },
      priority = 2,
      color = colors.warning,
    },
    Info = {
      text = { "-", "=" },
      priority = 3,
      color = colors.info,
    },
    Hint = {
      text = { "-", "=" },
      priority = 4,
      color = colors.hint,
    },
    Misc = {
      text = { "-", "=" },
      priority = 5,
      color = colors.purple,
    },
  },
  excluded_buftypes = {
    "terminal",
  },
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
  },
  autocmd = {
    render = {
      "BufWinEnter",
      "TabEnter",
      "TermEnter",
      "WinEnter",
      "CmdwinLeave",
      "TextChanged",
      "VimResized",
      "WinScrolled",
    },
    clear = {
      "BufWinLeave",
      "TabLeave",
      "TermLeave",
      "WinLeave",
    },
  },
  handlers = {
    diagnostic = true,
    search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
  },
}

require("scrollbar.handlers.search").setup({
  calm_dowm = true,
  nearest_only = true,
})
