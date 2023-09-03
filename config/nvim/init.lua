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
    'nvim-lua/plenary.nvim',
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd[[colorscheme tokyonight]]
    end,
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
      })
      vim.cmd[[
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
    'simrat39/symbols-outline.nvim',
    config = function()
      require("symbols-outline").setup()
    end
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
      --
      -- -- Eviline config for lualine
      -- Author: shadmansaleh
      -- Credit: glepnir
      local lualine = require('lualine')

      -- Color table for highlights
      -- stylua: ignore
      local colors = {
        bg       = '#202328',
        fg       = '#bbc2cf',
        yellow   = '#ECBE7B',
        cyan     = '#008080',
        darkblue = '#081633',
        green    = '#98be65',
        orange   = '#FF8800',
        violet   = '#a9a1e1',
        magenta  = '#c678dd',
        blue     = '#51afef',
        red      = '#ec5f67',
      }

      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand('%:p:h')
          local gitdir = vim.fn.finddir('.git', filepath .. ';')
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }

      -- Config
      local config = {
        options = {
          -- Disable sections and component separators
          component_separators = '',
          section_separators = '',
          theme = {
            -- We are going to use lualine_c an lualine_x as left and
            -- right section. Both are highlighted by c theme .  So we
            -- are just setting default looks o statusline
            normal = { c = { fg = colors.fg, bg = colors.bg } },
            inactive = { c = { fg = colors.fg, bg = colors.bg } },
          },
        },
        sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          -- These will be filled later
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          -- these are to remove the defaults
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      -- Inserts a component in lualine_c at left section
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end

      -- Inserts a component in lualine_x ot right section
      local function ins_right(component)
        table.insert(config.sections.lualine_x, component)
      end

      ins_left {
        function()
          return '▊'
        end,
        color = { fg = colors.blue }, -- Sets highlighting of component
        padding = { left = 0, right = 1 }, -- We don't need space before this
      }

      ins_left {
        -- mode component
        function()
          return ''
        end,
        color = function()
          -- auto change color according to neovims mode
          local mode_color = {
            n = colors.red,
            i = colors.green,
            v = colors.blue,
            [''] = colors.blue,
            V = colors.blue,
            c = colors.magenta,
            no = colors.red,
            s = colors.orange,
            S = colors.orange,
            [''] = colors.orange,
            ic = colors.yellow,
            R = colors.violet,
            Rv = colors.violet,
            cv = colors.red,
            ce = colors.red,
            r = colors.cyan,
            rm = colors.cyan,
            ['r?'] = colors.cyan,
            ['!'] = colors.red,
            t = colors.red,
          }
          return { fg = mode_color[vim.fn.mode()] }
        end,
        padding = { right = 1 },
      }

      ins_left {
        -- filesize component
        'filesize',
        cond = conditions.buffer_not_empty,
      }

      ins_left {
        'filename',
        cond = conditions.buffer_not_empty,
        color = { fg = colors.magenta, gui = 'bold' },
      }

      ins_left { 'location' }

      ins_left { 'progress', color = { fg = colors.fg, gui = 'bold' } }

      ins_left {
        'diagnostics',
        sources = { 'nvim_diagnostic' },
        symbols = { error = ' ', warn = ' ', info = ' ' },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
      }

      -- Insert mid section. You can make any number of sections in neovim :)
      -- for lualine it's any number greater then 2
      ins_left {
        function()
          return '%='
        end,
      }

      ins_left {
        -- Lsp server name .
        function()
          local msg = 'No Active Lsp'
          local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
          local clients = vim.lsp.get_active_clients()
          if next(clients) == nil then
            return msg
          end
          for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = ' LSP:',
        color = { fg = '#ffffff', gui = 'bold' },
      }

      -- Add components to right sections
      ins_right {
        'o:encoding', -- option component same as &encoding in viml
        fmt = string.upper, -- I'm not sure why it's upper case either ;)
        cond = conditions.hide_in_width,
        color = { fg = colors.green, gui = 'bold' },
      }

      ins_right {
        'fileformat',
        fmt = string.upper,
        icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
        color = { fg = colors.green, gui = 'bold' },
      }

      ins_right {
        'branch',
        icon = '',
        color = { fg = colors.violet, gui = 'bold' },
      }

      ins_right {
        'diff',
        -- Is it me or the symbol for modified us really weird
        symbols = { added = ' ', modified = '柳 ', removed = ' ' },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = conditions.hide_in_width,
      }

      ins_right {
        function()
          return '▊'
        end,
        color = { fg = colors.blue },
        padding = { left = 1 },
      }

      -- Now don't forget to initialize lualine
      lualine.setup(config)
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
          \ "globalJisyo": expand("~/.config/skk/SKK-JISYO.L"),
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
      require('skkeleton_indicator').setup{}
    end
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
      "ibhagwan/fzf-lua",              -- optional
    },
    config = function()
      local neogit = require('neogit')
      neogit.setup {}
    end
  },

})

-- set formatoptions-=c formatoptions-=r formatoptions-=o
require('base')
require('highlights')
vim.cmd 'source ~/.vim/keymap.vim'
