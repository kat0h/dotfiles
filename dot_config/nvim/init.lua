vim.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == "" then
        return false
      elseif type(v) == "table" and next(v) == nil then
        return false
      end
      return true
    end
  end,
})
vim.opt.backup = false
-- coding
vim.cmd [[ autocmd FileType Makfile setlocal noexpandtab ]]
vim.cmd [[
set autoindent
set tabstop=4
set shiftwidth=4
set noexpandtab
set number
]]
-- display
vim.opt.number = true
vim.opt.inccommand = 'split'
vim.opt.breakindent = true
vim.diagnostic.config({
  signs = false
})
vim.opt.wrap = true
-- search
vim.opt.ignorecase = true
-- terminal
vim.api.nvim_create_autocmd({'TermOpen'}, {
  pattern = {'*'},
  callback = function()
    vim.api.nvim_set_option_value('number', false, { scope = 'local' })
    vim.api.nvim_set_option_value('relativenumber', false, { scope = 'local' })
  end
})
-- key binding
vim.g.mapleader = ' '
vim.keymap.set({'n', 'i'}, '<esc>', '<cmd>noh<cr><esc>', {})
-- move
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l')
vim.api.nvim_set_keymap('n', '0', "getline('.')[0:col('.')-2]=~#'^\\s\\+$'?'0':'^'", {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('x', '0', "getline('.')[0:col('.')-2]=~#'^\\s\\+$'?'0':'^'", {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('o', '0', "getline('.')[0:col('.')-2]=~#'^\\s\\+$'?'0':'^'", {silent = true, noremap = true, expr = true})
vim.api.nvim_set_keymap('n', 'j', 'gj', {silent=true,noremap=true})
vim.api.nvim_set_keymap('n', 'k', 'gk', {silent=true,noremap=true})
-- buffer
vim.api.nvim_set_keymap('n', '[b', '<cmd>bnext<cr>', { desc = 'Previous buffer' })
vim.api.nvim_set_keymap('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
-- visual
vim.api.nvim_set_keymap('v', 'v', '$', { desc = "$" })
-- insert
vim.api.nvim_set_keymap('i', '<C-f>', '<right>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('i', '<C-b>', '<left>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('i', '<C-h>', '<bs>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('i', '<C-u>', '<esc>v^di', {silent=true, noremap=true})
vim.api.nvim_set_keymap('i', '<C-e>', '<end>', {silent=true, noremap=true})
vim.api.nvim_set_keymap('i', '<C-a>', '<home>', {silent=true, noremap=true})


function vim.g.get_start_directory()
  if vim.fn.argc() > 0 then
    return vim.fn.fnamemodify(vim.fn.argv()[1], ":p:h")
  end
  return vim.fn.getcwd()
end
if vim.bool_fn.has("vim_starting") then
  vim.cmd.cd(vim.g.get_start_directory())
end

local lazyconfig = {
  {
    'vim-denops/denops.vim',
    config = function()
      vim.g['denops#server#deno_args'] = {
        '--allow-all',
        '--unstable-kv',
      }
    end
  },
  -- Fuzzy Finder
  {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    keys = {
      { '<c-p>', '<cmd>Telescope find_files<cr>', desc = 'Find file' },
    },
    cmd = { 'Telescope' },
    config = function()
      require('telescope').setup({
        defaults = {
          mappings = {
            i = {
            }
          }
        }
      })
    end,
  },
  -- Keybiding
  {
    'delphinus/emcl.nvim',
    config = function()
      require('emcl').setup()
    end,
  },
  {
    'machakann/vim-sandwich',
    -- {s,S(in visual mode)}{a(ppend),r(eplace),d(elete)}
  },
  -- SKK
  {
    'vim-skk/skkeleton',
    lazy = false,
    dependencies = { 'vim-denops/denops.vim', 'delphinus/skkeleton_indicator.nvim' },
    config = function()
      -- 辞書: ~/.config/skk/SKK-JISYO.L
      -- データベース: ~/.cache/skkeleton.kv
      require('skkeleton_indicator').setup()
      local jisyo_path = vim.fn.expand('~/.config/skk')
      local jisyo = jisyo_path .. '/SKK-JISYO.L'
      if not vim.uv.fs_stat(jisyo) then
        print('downloading skk jisyo ...')
        vim.fn.mkdir(jisyo_path, 'p')
        vim.fn.system {
          'wget', 'http://openlab.jp/skk/dic/SKK-JISYO.L.gz',
          '-O', jisyo_path .. '/SKK-JISYO.L.gz'
        }
        vim.fn.system { 'gzip', '-d', jisyo_path .. '/SKK-JISYO.L.gz' }
      end
      vim.fn['skkeleton#config']({
        globalDictionaries = {jisyo},
        eggLikeNewline = true,
        databasePath = vim.fn.expand('~/.cache/skk.db'),
      })
      vim.keymap.set({ 'i', 'c' }, '<C-j>', '<Plug>(skkeleton-toggle)')
    end,
  },
  -- colorscheme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup{
        flavour = 'macchiato',
      }
      vim.cmd.colorscheme 'catppuccin'
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  -- UI
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = { theme = 'catppuccin', },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'filetype'},
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
      }
    end
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      -- 'rcarriga/nvim-notify',
    },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end
  },
  {
    'akinsho/bufferline.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('bufferline').setup({
        options = {
          separator_style = 'slant',
          indicator = {
            style = 'underline'
          },
        },
      })
    end
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      local anim = require('mini.animate')
      anim.setup({
        -- cursor = {
        --   timing = anim.gen_timing.linear()
        -- },
        scroll = {
          timing = anim.gen_timing.linear({ duration = 2 })
        },
        -- resize = {
        --   timing = anim.gen_timing.linear()
        -- },
        -- open = {
        --   timing = anim.gen_timing.linear()
        -- },
        -- close = {
        --   timing = anim.gen_timing.linear()
        -- },
      })
      require('mini.pairs').setup()
      vim.keymap.set({ 'i' }, '<C-h>', '<BS>', { remap = true })
      require('mini.indentscope').setup()
      require('mini.bracketed').setup()
    end
  },
  -- quickrun
  {
    'thinca/vim-quickrun',
    dependencies = { 'statiolake/vim-quickrun-runner-nvimterm' },
    cmd = { 'QuickRun' },
    config = function()
      vim.g.quickrun_config = {
        _ = {
          runner = 'nvimterm',
        }
      }
    end
  },
  -- file manager
  {
    'kyazdani42/nvim-tree.lua',
    keys = {
      { '<Leader>f', '<Cmd>NvimTreeToggle<CR>', mode = 'n' },
    },
    config = function()
      require('nvim-tree').setup({
        sort_by = 'case_sensitive',
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
        },
      })
    end
  },
  -- search files
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
      })
    end
  },
  -- LSP
  {
    'williamboman/mason.nvim',
    dependencies = {
      'winlliamboman/mason-lspconfig.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
      require('mason-lspconfig').setup_handlers({ function(server)
        local opt = {
          capabilities = require('cmp_nvim_lsp')
          .default_capabilities(vim.lsp.protocol.make_client_capabilities())
        }
        require('lspconfig')[server].setup(opt)
      end })
    end
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        'lazy.nvim',
      },
    },
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  -- completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/vim-vsnip',
      'hrsh7th/cmp-vsnip'
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        window = {
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        }),
      })
    end
  },
  {
    'hrsh7th/vim-vsnip',
    config = function()
      vim.cmd[[
        " Expand
        "imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
        "smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

        " Expand or jump
        imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
        smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

        " Jump forward or backward
        imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
        smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
        imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
        smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

        " Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
        nmap        s   <Plug>(vsnip-select-text)
        xmap        s   <Plug>(vsnip-select-text)
        nmap        S   <Plug>(vsnip-cut-text)
        xmap        S   <Plug>(vsnip-cut-text)
      ]]
    end
  },
  -- edit
  {
    'thinca/vim-partedit',
  },
  -- {
  --   'hrsh7th/nvim-dansa',
  --   config = function()
  --     local dansa = require('dansa')
  --     dansa.setup({
  --       enabled = true,
  --       scan_offset = 100,
  --       cutoff_count = 5,
  --       default = {
  --         expandtab = true,
  --         space = {
  --           shiftwidth = 2,
  --         },
  --         tab = {
  --           shiftwidth = 4,
  --         },
  --       }
  --     })
  --     dansa.setup.filetype('make', {
  --       enabled = true,
  --       scan_offset = 100,
  --       cutoff_count = 5,
  --       default = {
  --         expandtab = false,
  --       },
  --     })
  --   end
  -- },
  {
    'kana/vim-textobj-entire', -- ie ae
    dependencies = {
      'kana/vim-textobj-user'
    },
  },
  -- Document
  {
    'vim-jp/vimdoc-ja',
  },
}

require('lazy_setup')
require('lazy').setup(lazyconfig)

