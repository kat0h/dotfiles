-- `<CR>`            edit
-- `<C-e>`           edit_in_place
-- `O`               edit_no_picker
-- `<C-]>`           cd
-- `<C-v>`           vsplit
-- `<C-x>`           split
-- `<C-t>`           tabnew
-- `P`               parent_node
-- `<BS>`            close_node
-- `<Tab>`           preview
-- `K`               first_sibling
-- `J`               last_sibling
-- `I`               toggle_git_ignored
-- `H`               toggle_dotfiles
-- `R`               refresh
-- `a`               create
-- `d`               remove
-- `D`               trash
-- `r`               rename
-- `<C-r>`           full_rename
-- `x`               cut
-- `c`               copy
-- `p`               paste
-- `y`               copy_name
-- `Y`               copy_path
-- `gy`              copy_absolute_path
-- `-`               dir_up
-- `s`               system_open
-- `q`               close
-- `W`               collapse_all
-- `E`               expand_all
-- `f`               live_filter
-- `F`               clear_live_filter
-- `S`               search_node
-- `.`               run_file_command
-- `<C-k>`           toggle_file_info
-- `g?`              toggle_help

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

vim.cmd [[
  nnoremap <Space>f <Cmd>NvimTreeToggle<CR>
  " open file right pane
  set splitright
]]

-- auto clone filer window if it is the last window
-- This code is possibility Broken
vim.api.nvim_create_autocmd("BufEnter", {
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
      vim.cmd "quit"
    end
  end
})
