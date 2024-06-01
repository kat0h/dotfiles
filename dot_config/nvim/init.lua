require('base')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "folke/lazy.nvim",
  },
  {
    'https://github.com/thinca/vim-quickrun',
  },
  {
    'nvim-lua/plenary.nvim',
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[colorscheme tokyonight]]
    end,
  },
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach'
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'glepnir/lspsaga.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim'
    },
    config = function()
      require("neodev").setup({
        -- add any options here, or leave empty to use the default settings
      })
      require('mason').setup()

      require('mason-lspconfig').setup_handlers({ function(server)
        local node_root_dir = require('lspconfig').util.root_pattern("package.json")
        local is_node_repo = node_root_dir(vim.api.nvim_buf_get_name(0)) ~= nil
        local opt = {
          -- -- Function executed when the LSP server startup
          -- on_attach = function(client, bufnr)
          --   local opts = { noremap=true, silent=true }
          --   vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          --   vim.cmd 'autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)'
          -- end,
          capabilities = require('cmp_nvim_lsp').default_capabilities(
            vim.lsp.protocol.make_client_capabilities()
          )
        }


        if server_name == "tsserver" then
          if not is_node_repo then
            return
          end

          opt.root_dir = node_root_dir
        elseif server_name == "eslint" then
          if not is_node_repo then
            return
          end

          opt.root_dir = node_root_dir
        elseif server_name == "denols" then
          if is_node_repo then
            return
          end

          opt.root_dir = require('lspconfig').util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
          opt.init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true
                }
              }
            }
          }
        end

        require('lspconfig')[server].setup(opt)
        require('lspconfig')['rust_analyzer'].setup {
          on_attach = on_attach,
          flags = lsp_flags,
          -- Server-specific settings...
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy"
              }
            }
          }
        }


        require('fidget').setup()
      end })

      -- 2. build-in LSP function
      -- keyboard shortcut
      vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {})
      vim.keymap.set('n', 'gf', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', {})
      vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', {})
      -- TODO <C-]>に割り当てる
      vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', {})
      vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', {})
      vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', {})
      vim.keymap.set('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', {})
      vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<CR>', {})
      vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>', {})
      vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float()<CR>', {})
      vim.keymap.set('n', 'g]', '<cmd>lua vim.diagnostic.goto_next()<CR>', {})
      vim.keymap.set('n', 'g[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', {})
      -- LSP handlers
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, { virtual_text = false }
      )
      -- Reference highlight
      vim.cmd [[
      set updatetime=500
      highlight LspReferenceText  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
      highlight LspReferenceRead  cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
      highlight LspReferenceWrite cterm=underline ctermfg=1 ctermbg=8 gui=underline guifg=#A00000 guibg=#104040
      augroup lsp_document_highlight
      autocmd!
      autocmd CursorHold,CursorHoldI * lua vim.lsp.buf.document_highlight()
      autocmd CursorMoved,CursorMovedI * lua vim.lsp.buf.clear_references()
      augroup END
      ]]
    end
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
    },
    config = function()
      -- 3. completion (hrsh7th/nvim-cmp)
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete({}),
          ['<C-e>'] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        }),
        experimental = {
          ghost_text = true,
        },
      })

      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path" },
          { name = "cmdline" },
        },
      })
    end
  },
  {
    'kyazdani42/nvim-tree.lua',
    keys = {
      { "<Space>f", "<Cmd>NvimTreeToggle<CR>", mode = "n" },
    },
    config = function()
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
        diagnostics = {
          enable = true,
        }
      })
      vim.cmd [[
      set splitright
      ]]
    end
  },
  {
    'kat0h/bufpreview.vim',
    lazy = false,
    build = 'deno task prepare'
  },
  {
    'vim-denops/denops.vim',
    lazy = false,
  },
  {
    'vim-jp/vimdoc-ja',
  },
  {
    'kyazdani42/nvim-web-devicons',
  },
  {
    'windwp/nvim-autopairs',
    config = function()
      require("nvim-autopairs").setup {}
    end
  },
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      { "<Space>t", "<Cmd>Telescope fd<CR>", mode = "n" },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      local colors = require("tokyonight.colors").setup()
      require("scrollbar").setup {
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

      require("scrollbar.handlers.gitsigns").setup()
    end
  },
  {
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('hlslens').setup()
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      -- vim.opt.laststatus = 3
      local lualine = require('lualine')
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'auto',
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
      lualine.setup()
    end
  },
  {
    'delphinus/emcl.nvim',
  },
  {
    'monaqa/dial.nvim',
    config = function()
      vim.cmd [[
      nmap  <C-a>  <Plug>(dial-increment)
      nmap  <C-x>  <Plug>(dial-decrement)
      vmap  <C-a>  <Plug>(dial-increment)
      vmap  <C-x>  <Plug>(dial-decrement)
      vmap g<C-a> g<Plug>(dial-increment)
      vmap g<C-x> g<Plug>(dial-decrement)
      ]]
    end
  },
  {
    'machakann/vim-sandwich',
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {}
    end
  },
  {
    'vim-skk/skkeleton',
    lazy = false,
    dependencies = {
      'vim-denops/denops.vim',
    },
    config = function()
      vim.cmd [[
      " skkeleten
      " ==============================================================================
      if !filereadable(expand('~/.config/skk/SKK-JISYO.L'))
        call mkdir(expand('~/.config/skk'), 'p')
        call system('cd ~/.config/skk && wget http://openlab.jp/skk/dic/SKK-JISYO.L.gz && gzip -d SKK-JISYO.L.gz')
        endif
        imap <C-j> <Plug>(skkeleton-toggle)
        cmap <C-j> <Plug>(skkeleton-toggle)
        call skkeleton#config({
          \ "globalDictionaries": [expand("~/.config/skk/SKK-JISYO.L")],
          \ "eggLikeNewline": v:true,
          \})

          call skkeleton#register_kanatable('rom', {
            \   ',': ['，', ''],
            \   '.': ['．', ''],
            \ })
      ]]
    end
  },
  {
    'delphinus/skkeleton_indicator.nvim',
    dependencies = { 'vim-skk/skkeleton' },
    event = "InsertEnter",
    config = function()
      require('skkeleton_indicator').setup {}
    end
  },
})

-- set formatoptions-=c formatoptions-=r formatoptions-=o
require('highlights')
vim.cmd 'source ~/.vim/keymap.vim'
