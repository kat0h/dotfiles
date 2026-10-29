-- Run fenced code blocks in Markdown with vim-quickrun.
--
-- The info string is "<lang> [quickrun args]". Obsidian and other renderers
-- only look at the first word, so the rest is free for quickrun:
--
--   ```lisp scheme -hook/eval/enable 1
--   (define (add1 x) (+ x 1))
--   (add1 2)
--   ```
--
-- With no args the language name is used as the quickrun type. Args that start
-- with "-" keep the language as the type; otherwise the first arg is the type.

local M = {}

local ns = vim.api.nvim_create_namespace("md_run")
local label = " ▶ Run "

local query = vim.treesitter.query.parse("markdown", "(fenced_code_block (info_string) @info) @block")

--- Closed fenced blocks with a language: { open = lnum, close = lnum, lang, args } (1-based)
local function find_blocks(bufnr)
	local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
	if not ok or not parser then
		return {}
	end
	local blocks = {}
	for _, match in query:iter_matches(parser:parse()[1]:root(), bufnr) do
		local block, info
		for id, nodes in pairs(match) do
			if query.captures[id] == "block" then
				block = nodes[1]
			else
				info = nodes[1]
			end
		end
		-- An unclosed block has only the opening delimiter.
		local delimiters = {}
		for child in block:iter_children() do
			if child:type() == "fenced_code_block_delimiter" then
				table.insert(delimiters, child)
			end
		end
		if #delimiters == 2 then
			local lang, args = vim.treesitter.get_node_text(info, bufnr):match("^(%S+)%s*(.-)%s*$")
			table.insert(blocks, {
				open = block:start() + 1,
				close = delimiters[2]:start() + 1,
				lang = lang,
				args = args,
			})
		end
	end
	return blocks
end

local function block_at(bufnr, lnum)
	for _, b in ipairs(find_blocks(bufnr)) do
		if lnum >= b.open and lnum <= b.close then
			return b
		end
	end
end

local function quickrun_args(b)
	if b.args == "" then
		return b.lang
	elseif b.args:sub(1, 1) == "-" then
		return b.lang .. " " .. b.args
	end
	return b.args
end

local function run(b)
	if b.close - b.open < 2 then
		vim.notify("md_run: empty code block", vim.log.levels.WARN)
		return
	end
	vim.cmd(("%d,%dQuickRun %s"):format(b.open + 1, b.close - 1, quickrun_args(b)))
end

--- Fence line whose button is under the mouse, per buffer
local hovered = {}

local function refresh(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	for _, b in ipairs(find_blocks(bufnr)) do
		vim.api.nvim_buf_set_extmark(bufnr, ns, b.open - 1, 0, {
			virt_text = { { label, hovered[bufnr] == b.open and "MdRunHover" or "MdRun" } },
			virt_text_pos = "right_align",
		})
	end
end

--- The block whose "▶ Run" button is under the mouse, if any.
local function block_under_mouse(bufnr)
	local pos = vim.fn.getmousepos()
	if pos.winid ~= vim.api.nvim_get_current_win() or pos.line == 0 then
		return
	end
	if pos.wincol <= vim.api.nvim_win_get_width(pos.winid) - vim.fn.strdisplaywidth(label) then
		return
	end
	local b = block_at(bufnr, pos.line)
	if b and b.open == pos.line then
		return b
	end
end

--- Run the block under the cursor.
function M.run_current()
	local b = block_at(0, vim.api.nvim_win_get_cursor(0)[1])
	if b then
		run(b)
	else
		vim.notify("md_run: not inside a fenced code block", vim.log.levels.WARN)
	end
end

function M.attach(bufnr)
	refresh(bufnr)
	-- Redraw the buttons once edits pause instead of on every change.
	local timer = assert(vim.uv.new_timer())
	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		buffer = bufnr,
		callback = function()
			timer:start(150, 0, vim.schedule_wrap(function()
				if vim.api.nvim_buf_is_valid(bufnr) then
					refresh(bufnr)
				end
			end))
		end,
	})
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = bufnr,
		callback = function()
			timer:close()
			hovered[bufnr] = nil
		end,
	})

	-- <CR> on an opening fence runs the block; elsewhere it keeps its default.
	vim.keymap.set("n", "<CR>", function()
		local lnum = vim.api.nvim_win_get_cursor(0)[1]
		local b = block_at(bufnr, lnum)
		if b and b.open == lnum then
			-- Expr mappings may not open windows, so run after the mapping returns.
			vim.schedule(function()
				run(b)
			end)
			return ""
		end
		return "<CR>"
	end, { buffer = bufnr, expr = true, desc = "Run code block (on its fence)" })

	-- Clicking "▶ Run" at the right edge of an opening fence line runs the block.
	vim.keymap.set("n", "<LeftMouse>", function()
		local b = block_under_mouse(bufnr)
		if b then
			vim.schedule(function()
				run(b)
			end)
			return ""
		end
		return "<LeftMouse>"
	end, { buffer = bufnr, expr = true, desc = "Run code block (click ▶ Run)" })

	-- Highlight the button under the mouse (needs 'mousemoveevent').
	vim.keymap.set("n", "<MouseMove>", function()
		local b = block_under_mouse(bufnr)
		local line = b and b.open or nil
		if hovered[bufnr] ~= line then
			hovered[bufnr] = line
			refresh(bufnr)
		end
	end, { buffer = bufnr, desc = "Highlight ▶ Run under the mouse" })

	vim.keymap.set("n", "<leader>mr", M.run_current, { buffer = bufnr, desc = "Run code block under cursor" })
end

function M.setup()
	vim.api.nvim_set_hl(0, "MdRun", { link = "DiagnosticVirtualTextOk", default = true })
	vim.api.nvim_set_hl(0, "MdRunHover", { link = "IncSearch", default = true })
	vim.o.mousemoveevent = true

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		group = vim.api.nvim_create_augroup("md_run", { clear = true }),
		callback = function(args)
			M.attach(args.buf)
		end,
	})
end

return M
