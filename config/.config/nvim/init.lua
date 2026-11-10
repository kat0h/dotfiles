-- Neovim config (derived from kickstart.nvim)
--
-- NOTE: 改修計画
-- - LSPを明示的に有効にしない限り、無効にする
-- - restartコマンドでセッションが復元されるようにしたい
-- - ディレクトリごとにセッションを保持したい
-- - nvimの中にいる かつ skk-fcitx5が有効 → 無効にする

-- [[ SKK Implementation Switch ]]
-- true: skkeleton.nvim (Lua版), false: skkeleton (denops版)
local use_skkeleton_nvim = true

-- [[ Globals ]]
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Options ]]
-- UI
vim.fn.setcellwidths({ { 0x25BC, 0x25BC, 1 }, { 0x25BD, 0x25BD, 1 } })
vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false -- already shown in the statusline
vim.o.signcolumn = "yes"
vim.o.cursorline = true
vim.o.winborder = "rounded" -- rounded borders on floating windows (hover, diagnostics, etc.)
vim.o.laststatus = 3 -- one global statusline
vim.o.smoothscroll = true -- scroll wrapped lines smoothly
vim.opt.fillchars = { eob = " " } -- hide `~` past the end of the buffer
vim.o.scrolloff = 10
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.inccommand = "split" -- preview substitutions live
vim.o.splitright = true
vim.o.splitbelow = true

-- Editing
vim.o.breakindent = true
vim.o.undofile = true
vim.o.confirm = true -- ask to save instead of failing on e.g. `:q`
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 2
vim.o.smarttab = true

-- Search: case-insensitive unless \C or a capital letter is used
vim.o.ignorecase = true
vim.o.smartcase = true

-- Timing
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- [[ Keymaps ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Split navigation with CTRL+<hjkl>
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- `0` jumps to the first non-blank character; pressing it again (cursor already
-- inside the leading whitespace) jumps to column 0
for _, mode in ipairs({ "n", "x", "o" }) do
	vim.api.nvim_set_keymap(
		mode,
		"0",
		"getline('.')[0:col('.')-2]=~#'^\\s\\+$'?'0':'^'",
		{ silent = true, noremap = true, expr = true }
	)
end

vim.api.nvim_set_keymap("v", "v", "$", { desc = "$" })

-- Emacs-like movement in insert mode
vim.keymap.set("i", "<C-h>", "<Backspace>")
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-b>", "<Left>")
vim.keymap.set("i", "<C-n>", "<Down>")
vim.keymap.set("i", "<C-p>", "<Up>")
vim.keymap.set("i", "<C-a>", "<Home>")
vim.keymap.set("i", "<C-e>", "<End>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "gj", "j")
vim.keymap.set("n", "gk", "k")

-- NOTE: 設定したい
-- gfとgFを入れ換える
-- https://github.com/lambdalisue/vim-gf-improved

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Plugins ]]
require("lazy").setup({
	-- ── Git ────────────────────────────────────────────────────────────────
	{ -- Keymaps (on_attach) come from kickstart.plugins.gitsigns; lazy.nvim merges both opts
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "\u{F0DA}" }, -- nf-fa-caret_right
				topdelete = { text = "\u{F0DA}" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			-- Show author, date and summary of the last change at the end of the cursor line
			current_line_blame = true,
			current_line_blame_opts = { delay = 500 },
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		},
	},
	{
		"lambdalisue/vim-gin",
		dependencies = { "vim-denops/denops.vim" },
	},

	-- ── Markdown ───────────────────────────────────────────────────────────
	{
		dir = "~/ghq/github.com/kat0h/bufpreview.vim",
		dependencies = { "vim-denops/denops.vim" },
		build = "deno task prepare",
		lazy = false,
	},
	{ -- Render Markdown in Neovim (images need the Kitty graphics protocol)
		"delphinus/md-render.nvim",
		version = "*",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", version = "*" }, -- file type icons in code blocks
			{ "delphinus/budoux.lua", version = "*" }, -- phrase-level line breaking for Japanese
		},
		config = function()
			-- Kitty's text sizing protocol garbles and flickers the enlarged headings.
			require("md-render.text_size").setup({ enabled = false })
		end,
		keys = {
			{
				"<leader>mp",
				function()
					-- :MdRender split always opens another window, so close an existing preview instead.
					local buf = vim.api.nvim_get_current_buf()
					local closed = false
					for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
						local ok, state = pcall(vim.api.nvim_win_get_var, win, "md_render_state")
						if ok and type(state) == "table" and state.mode == "render" and state.source_buf == buf then
							vim.api.nvim_win_close(win, false)
							closed = true
						end
					end
					if not closed then
						vim.cmd("vertical botright MdRender split")
					end
				end,
				desc = "Markdown preview on the right (toggle)",
			},
			{ "<leader>mf", "<Plug>(md-render-preview)", desc = "Markdown preview in float (toggle)" },
			{ "<leader>mt", "<Plug>(md-render-preview-tab)", desc = "Markdown preview in tab (toggle)" },
			{ "<leader>md", "<Plug>(md-render-demo)", desc = "Markdown render demo" },
		},
	},

	-- ── UI ─────────────────────────────────────────────────────────────────
	{ -- Show pending keybinds
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				-- With a Nerd Font, an empty table uses which-key's default icons
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
		config = function(_, opts)
			require("which-key").setup(opts)

			-- <C-o>zz のような 1 コマンドが、which-key の normal モードの trigger（z など）に
			-- 奪われるのを避ける。実行するキーの前に <C-o> を流し直す。
			-- which-key #1033 と PR #879 が入ったら消す。
			local state = require("which-key.state")
			local execute = state.execute
			state.execute = function(st, key, node)
				local in_ctrl_o = vim.api.nvim_get_mode().mode:find("^ni[IRV]") ~= nil
				local ret = execute(st, key, node)
				if in_ctrl_o and not (node and node.action) then
					vim.api.nvim_feedkeys(vim.keycode("<C-o>"), "nit", false)
				end
				return ret
			end
		end,
	},
	{ -- Colorscheme: muted, paper-like Kanagawa. The `neovim` branch is the installable runtime.
		"thesimonho/kanagawa-paper.nvim",
		branch = "neovim",
		lazy = false,
		priority = 1000, -- Load before all the other start plugins
		config = function()
			require("kanagawa-paper").setup({})
			vim.cmd.colorscheme("kanagawa-paper-ink")
		end,
	},
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}, -- icons in the sign column (Nerd Font)
	},
	{
		"junegunn/goyo.vim",
		config = function()
			-- ctrl-w oを入れ換える
			-- Goyoを有効にしている時はcolorful-winsep.nvimをオフにする
			-- もしcolorful-winsepが読まれているなら
		end,
	},

	-- ── Finder / file explorer ─────────────────────────────────────────────
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					prompt_prefix = "\u{F002}  ", -- nf-fa-search
					selection_caret = "\u{F054} ", -- nf-fa-chevron_right
					-- <Esc> in the prompt closes Telescope instead of entering normal mode.
					-- While skkeleton is on it takes <Esc> buffer-locally, so <Esc> still confirms the preedit first.
					mappings = {
						i = { ["<Esc>"] = "close" },
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeOpen" },
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<cr>", mode = "n", desc = "toggle [e]xplorer" },
		},
		config = function()
			-- 各行に +追加 -削除 の行数を右端に出す（lua/custom/nvim_tree_diffstat.lua）
			local diffstat = require("custom.nvim_tree_diffstat")
			require("nvim-tree").setup({
				view = {
					width = 60,
				},
				-- Follow :cd / :lcd
				sync_root_with_cwd = true,
				-- Reveal the current buffer's file, re-rooting when it lives outside the tree
				update_focused_file = {
					enable = true,
					update_root = { enable = true },
				},
				-- Git status badges
				git = {
					enable = true,
					show_on_dirs = true, -- mark directories containing changes
					show_on_open_dirs = true,
					timeout = 1000,
				},
				renderer = {
					highlight_git = "name", -- color file names by git status
					decorators = {
						"Git",
						"Open",
						"Hidden",
						"Modified",
						"Bookmark",
						"Diagnostics",
						"Copied",
						diffstat.Decorator,
						"Cut",
					},
					icons = {
						git_placement = "after", -- badge after the file name
						show = { git = true },
						glyphs = {
							-- Nerd Font (Octicons)
							git = {
								unstaged = "\u{F459}", -- nf-oct-diff_modified
								staged = "\u{F457}", -- nf-oct-diff_added
								unmerged = "\u{F419}", -- nf-oct-git_merge
								renamed = "\u{F45A}", -- nf-oct-diff_renamed
								untracked = "\u{F128}", -- nf-fa-question
								deleted = "\u{F458}", -- nf-oct-diff_removed
								ignored = "\u{F474}", -- nf-oct-diff_ignored
							},
						},
					},
				},
				filesystem_watchers = { enable = true },
				-- LSP errors/warnings in the tree, propagated to parent directories
				diagnostics = {
					enable = true,
					show_on_dirs = true,
				},
				-- Mark files with unsaved changes
				modified = { enable = true },
			})
			diffstat.setup()
		end,
	},

	-- ── LSP ────────────────────────────────────────────────────────────────
	{ -- Lua LSP for the Neovim config, runtime and plugins
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Mason must be loaded before its dependents so we need to set it up here.
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} }, -- LSP status updates
			"saghen/blink.cmp", -- extra LSP capabilities
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					local telescope = require("telescope.builtin")
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", telescope.lsp_references, "[G]oto [R]eferences")
					map("gri", telescope.lsp_implementations, "[G]oto [I]mplementation")
					map("grd", telescope.lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", telescope.lsp_document_symbols, "Open Document Symbols")
					map("gW", telescope.lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", telescope.lsp_type_definitions, "[G]oto [T]ype Definition")

					local client = vim.lsp.get_client_by_id(event.data.client_id)

					-- Highlight references of the word under the cursor while it rests there
					if
						client
						and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					prefix = function(diagnostic)
						local icons = vim.g.have_nerd_font
								and { "󰅚", "󰀪", "󰋽", "󰌶" } -- ERROR, WARN, INFO, HINT
							or { "●", "●", "●", "●" }
						return icons[diagnostic.severity]
					end,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Language servers to install and enable, with per-server overrides
			-- (cmd, filetypes, capabilities, settings)
			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			-- jdtls: lspconfig names the workspace by the root's basename only, so git worktrees
			-- (res/language and res-prelim-7/language) shared one workspace and broke the Gradle import.
			-- Add a hash of the full path to keep one workspace per root.
			vim.lsp.config("jdtls", {
				cmd = function(dispatchers, config)
					local root = config.root_dir or vim.fn.getcwd()
					local name = vim.fn.fnamemodify(root, ":t") .. "-" .. vim.fn.sha256(root):sub(1, 8)
					local data = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. name
					return vim.lsp.rpc.start({ "jdtls", "-data", data }, dispatchers, {
						cwd = config.cmd_cwd,
						env = config.cmd_env,
						detached = config.detached,
					})
				end,
			})

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- installs are handled by mason-tool-installer
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- Only override capabilities explicitly set in the server config above
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},

	-- ── Completion ─────────────────────────────────────────────────────────
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				opts = {},
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				-- See :h blink-cmp-config-keymap
				preset = "super-tab",
				["<Space>"] = {},
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				menu = { border = "rounded" },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 300,
					window = { border = "rounded" },
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					},
				},
			},
			sources = {
				-- Only offer skkeleton candidates while skkeleton is active
				default = function()
					local active = false
					if use_skkeleton_nvim then
						local ok, skk = pcall(require, "skkeleton")
						active = ok and skk.is_enabled()
					else
						local enabled = vim.g["skkeleton#enabled"]
						active = enabled == true or enabled == 1
					end
					if active then
						return { "skkeleton" }
					else
						return { "lsp", "path", "snippets", "lazydev", "buffer" }
					end
				end,
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					skkeleton = use_skkeleton_nvim and {
						name = "skkeleton",
						module = "skkeleton.completion.blink",
					} or {
						name = "skkeleton",
						module = "blink-cmp-skkeleton",
					},
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true, window = { border = "rounded" } },
		},
	},

	-- ── Treesitter ─────────────────────────────────────────────────────────
	{ -- Highlighting. Parsers are installed on first use of each filetype.
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			local available = ts.get_available()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					local lang = vim.treesitter.language.get_lang(ev.match)
					if not vim.tbl_contains(available, lang) then
						return
					end
					ts.install(lang):await(vim.schedule_wrap(function()
						if vim.api.nvim_buf_is_valid(ev.buf) then
							pcall(vim.treesitter.start, ev.buf, lang)
						end
					end))
				end,
			})
		end,
	},

	-- ── Editing ────────────────────────────────────────────────────────────
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		lazy = false,
		config = function()
			-- Better Around/Inside textobjects (plus `N` for numbers)
			local gen_ai_spec = require("mini.extra").gen_ai_spec
			require("mini.ai").setup({
				n_lines = 500,
				custom_textobjects = {
					N = gen_ai_spec.number(),
				},
			})

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			require("mini.surround").setup({
				custom_surroundings = {
					-- LaTeX command
					["\\"] = {
						output = function()
							if vim.bo.filetype == "tex" then
								local cmd = MiniSurround.user_input("Command?")
								if cmd == "begin" then
									local env = MiniSurround.user_input("Environment?")
									return {
										left = "\\begin{" .. env .. "}\n",
										right = "\n\\end{" .. env .. "}",
									}
								else
									return { left = "\\" .. cmd .. "{", right = "}" }
								end
							else
								return { left = "\\", right = "\\" }
							end
						end,
					},
				},
			})

			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			-- Cursor location as LINE:COLUMN
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			require("mini.files").setup()

			-- Underline other occurrences of the word under the cursor
			require("mini.cursorword").setup()

			-- Auto-close brackets and quotes
			require("mini.pairs").setup()

			-- Paint hex color codes (#rrggbb) with their own color.
			-- TODO/FIXME highlighting is left to todo-comments.nvim.
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},
	{
		"Bakudankun/BackAndForward.vim",
		config = function()
			-- :set jumpoptions+=stack
			-- TODO: キーバインドを設定
			-- neotreeを無視するようにしたいかな
		end,
	},
	{ "lambdalisue/vim-suda" },
	{
		"delphinus/emcl.nvim",
		config = function()
			require("emcl").setup()
		end,
	},
	{
		"thinca/vim-quickrun",
		config = function()
			-- ▶ Run buttons on Markdown code fences (lua/custom/md_run.lua)
			require("custom.md_run").setup()
		end,
	},

	-- ── Japanese input (denops / lua) ────────────────────────────────────
	{
		"vim-denops/denops.vim",
		config = function()
			vim.g["denops#server#deno_args"] = {
				"--allow-all",
				"--unstable-kv",
			}
		end,
	},
	-- 元の skkeleton（denops 版）
	{
		"vim-skk/skkeleton",
		enabled = not use_skkeleton_nvim,
		lazy = false,
		dependencies = {
			"vim-denops/denops.vim",
			"delphinus/skkeleton_indicator.nvim",
			"Xantibody/blink-cmp-skkeleton",
		},
		config = function()
			-- 辞書: ~/.config/skk/SKK-JISYO.L
			-- データベース: ~/.cache/skkeleton.kv
			require("skkeleton_indicator").setup()
			local jisyo_path = vim.fn.expand("~/.config/skk")
			local jisyo = jisyo_path .. "/SKK-JISYO.L"
			if not vim.uv.fs_stat(jisyo) then
				print("downloading skk jisyo ...")
				vim.fn.mkdir(jisyo_path, "p")
				vim.fn.system({
					"wget",
					"http://openlab.jp/skk/dic/SKK-JISYO.L.gz",
					"-O",
					jisyo_path .. "/SKK-JISYO.L.gz",
				})
				vim.fn.system({ "gzip", "-d", jisyo_path .. "/SKK-JISYO.L.gz" })
			end
			vim.fn["skkeleton#config"]({
				globalDictionaries = { jisyo },
				eggLikeNewline = true,
				-- The database is only used with the deno_kv source (needs --unstable-kv).
				sources = { "deno_kv" },
				databasePath = vim.fn.expand("~/.cache/skk.db"),
			})
			-- Load the dictionary as soon as skkeleton is up instead of blocking on
			-- the first enable (see :h skkeleton-faq).
			vim.api.nvim_create_autocmd("User", {
				pattern = "DenopsPluginPost:skkeleton",
				once = true,
				callback = function()
					vim.fn["skkeleton#initialize"]()
				end,
			})
			vim.fn["skkeleton#register_kanatable"]("rom", {
				[","] = { "，", "" },
				["."] = { "．", "" },
			})
			vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-toggle)")
		end,
	},
	-- skkeleton.nvim（Lua 版。手元のリポジトリから読む）
	{
		dir = "~/ghq/github.com/kat0h/skkeleton.nvim",
		name = "skkeleton.nvim",
		enabled = use_skkeleton_nvim,
		lazy = false,
		config = function()
			local jisyo_path = vim.fn.expand("~/.config/skk")
			local jisyo = jisyo_path .. "/SKK-JISYO.L"
			if not vim.uv.fs_stat(jisyo) then
				print("downloading skk jisyo ...")
				vim.fn.mkdir(jisyo_path, "p")
				vim.fn.system({
					"wget",
					"http://openlab.jp/skk/dic/SKK-JISYO.L.gz",
					"-O",
					jisyo_path .. "/SKK-JISYO.L.gz",
				})
				vim.fn.system({ "gzip", "-d", jisyo_path .. "/SKK-JISYO.L.gz" })
			end
			local skkeleton = require("skkeleton")
			skkeleton.setup({
				globalDictionaries = { jisyo },
				completionRankFile = vim.fn.expand("~/.config/skk/rank.json"),
				eggLikeNewline = true,
				popupBorder = "rounded",
			})
			require("skkeleton.indicator").setup({
				style = "pill",
				fadeOutMs = 2500,
				showInCmdline = true,
			})
			skkeleton.register_kanatable("rom", {
				[","] = { "，", "" },
				["."] = { "．", "" },
			})
			-- 辞書の DB を起動直後に UI を止めずに用意する
			skkeleton.initialize()
			vim.keymap.set({ "i", "c" }, "<C-j>", "<Plug>(skkeleton-toggle)")
		end,
	},

	-- ── Kickstart extras (lua/kickstart/plugins) ───────────────────────────
	require("kickstart.plugins.indent_line"),
	require("kickstart.plugins.lint"),
	require("kickstart.plugins.gitsigns"), -- adds gitsigns recommend keymaps
}, {
	ui = {
		-- With a Nerd Font, an empty table uses lazy.nvim's default icons
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- vim: ts=2 sts=2 sw=2 et
