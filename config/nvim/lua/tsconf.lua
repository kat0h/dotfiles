require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "lua", "rust", "vim", "python", "typescript" },
  auto_install = true,
  highlight = {
    enable = true,
  },
}
