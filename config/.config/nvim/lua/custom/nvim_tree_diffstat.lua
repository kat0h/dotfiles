-- nvim-tree の各行に `git diff --numstat HEAD` の追加/削除行数を表示する Decorator。
-- ディレクトリには配下のファイルの合計を出す。
--
-- 結果は非同期に取得してキャッシュし、値が変わったときだけツリーを再描画する。

local api = require("nvim-tree.api")

local M = {}

---@type table<string, { add: integer, del: integer }> 絶対パス → 行数
local stats = {}
local running = false
local pending = false -- 実行中に来た更新要求。終わったらもう一度走らせる
local last_run = 0
local THROTTLE_MS = 500

local function same(a, b)
	if vim.tbl_count(a) ~= vim.tbl_count(b) then
		return false
	end
	for k, v in pairs(a) do
		local w = b[k]
		if not w or w.add ~= v.add or w.del ~= v.del then
			return false
		end
	end
	return true
end

local function tree_root()
	local ok, core = pcall(require, "nvim-tree.core")
	return ok and core.get_cwd() or vim.uv.cwd()
end

local function finish()
	running = false
	if pending then
		pending = false
		vim.schedule(function()
			M.refresh(true)
		end)
	end
end

local function parse(toplevel, out)
	local res = {}
	for line in out:gmatch("[^\n]+") do
		local add, del, path = line:match("^(%S+)\t(%S+)\t(.+)$")
		-- バイナリは "-\t-" になるので数値でないものは飛ばす
		add, del = tonumber(add), tonumber(del)
		if add and del then
			-- リネームは "old => new" や "dir/{a => b}" になるので新しい側を使う
			path = path:gsub("{[^}]* => ([^}]*)}", "%1"):gsub("^.* => ", ""):gsub("//", "/")
			local abs = toplevel .. "/" .. path
			-- ファイル自身と、リポジトリのルートまでの各ディレクトリに加算する
			local p = abs
			while p and #p >= #toplevel do
				local s = res[p] or { add = 0, del = 0 }
				s.add, s.del = s.add + add, s.del + del
				res[p] = s
				if p == toplevel then
					break
				end
				p = vim.fs.dirname(p)
			end
		end
	end
	return res
end

function M.refresh(force)
	local now = vim.uv.now()
	if running then
		pending = pending or force
		return
	end
	if not force and now - last_run < THROTTLE_MS then
		return
	end
	running, last_run = true, now

	local root = tree_root()
	vim.system({ "git", "-C", root, "rev-parse", "--show-toplevel" }, { text = true }, function(r)
		if r.code ~= 0 then
			finish()
			vim.schedule(function()
				if next(stats) then
					stats = {}
					api.tree.reload()
				end
			end)
			return
		end
		local toplevel = vim.trim(r.stdout)
		vim.system(
			{ "git", "-C", toplevel, "diff", "--numstat", "HEAD" },
			{ text = true },
			function(d)
				finish()
				local new = d.code == 0 and parse(toplevel, d.stdout) or {}
				vim.schedule(function()
					if not same(stats, new) then
						stats = new
						api.tree.reload()
					end
				end)
			end
		)
	end)
end

local Decorator = api.Decorator:extend()

function Decorator:new()
	self.enabled = true
	self.highlight_range = "none"
	self.icon_placement = "right_align"
end

function Decorator:icons(node)
	local s = node.absolute_path and stats[node.absolute_path]
	if not s then
		return nil
	end
	local icons = {}
	if s.add > 0 then
		table.insert(icons, { str = "+" .. s.add, hl = { "NvimTreeDiffAdd" } })
	end
	if s.del > 0 then
		table.insert(icons, { str = "-" .. s.del, hl = { "NvimTreeDiffDelete" } })
	end
	return icons
end

M.Decorator = Decorator

function M.setup()
	vim.api.nvim_set_hl(0, "NvimTreeDiffAdd", { link = "Added", default = true })
	vim.api.nvim_set_hl(0, "NvimTreeDiffDelete", { link = "Removed", default = true })

	-- 描画のたびに確認する（ファイル監視による再描画も拾える）。値が同じなら再描画しないのでループしない。
	api.events.subscribe(api.events.Event.TreeRendered, function()
		M.refresh(false)
	end)
	local group = vim.api.nvim_create_augroup("NvimTreeDiffstat", { clear = true })
	vim.api.nvim_create_autocmd({ "BufWritePost", "FocusGained", "ShellCmdPost", "TermLeave", "DirChanged" }, {
		group = group,
		callback = function()
			M.refresh(true)
		end,
	})
	M.refresh(true)
end

return M
