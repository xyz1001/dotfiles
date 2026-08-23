local M = {}

-- 格式化 JSON 字符串（纯 Lua 实现，100% 保持原始键顺序）
function M.format_json(json_str)
	local indent_str = "  "
	local level = 0
	local in_str = false
	local escape = false
	local result = {}
	local cur_line = ""
	local len = #json_str
	local i = 1

	while i <= len do
		local char = json_str:sub(i, i)
		if in_str then
			cur_line = cur_line .. char
			if escape then
				escape = false
			elseif char == "\\" then
				escape = true
			elseif char == '"' then
				in_str = false
			end
			i = i + 1
		else
			if char == '"' then
				in_str = true
				cur_line = cur_line .. char
				i = i + 1
			elseif char == " " or char == "\t" or char == "\r" or char == "\n" then
				i = i + 1
			elseif char == "{" or char == "[" then
				local rest = json_str:sub(i + 1)
				local closing_char = (char == "{") and "}" or "]"
				local empty_match = rest:match("^%s*" .. (char == "{" and "%}" or "%]"))
				if empty_match then
					cur_line = cur_line .. char .. closing_char
					local close_pos = json_str:find(closing_char, i + 1, true)
					i = (close_pos or (i + 1)) + 1
				else
					cur_line = cur_line .. char
					table.insert(result, cur_line)
					level = level + 1
					cur_line = string.rep(indent_str, level)
					i = i + 1
				end
			elseif char == "}" or char == "]" then
				level = math.max(0, level - 1)
				if cur_line:match("^%s*$") then
					cur_line = string.rep(indent_str, level) .. char
				else
					table.insert(result, cur_line)
					cur_line = string.rep(indent_str, level) .. char
				end
				i = i + 1
			elseif char == "," then
				cur_line = cur_line .. char
				table.insert(result, cur_line)
				cur_line = string.rep(indent_str, level)
				i = i + 1
			elseif char == ":" then
				cur_line = cur_line .. ": "
				i = i + 1
			else
				cur_line = cur_line .. char
				i = i + 1
			end
		end
	end

	if #cur_line > 0 and not cur_line:match("^%s*$") then
		table.insert(result, cur_line)
	end

	return result
end

-- 从单行或多行文本中智能提取 JSON
function M.extract_json(text, col)
	if not text or text == "" then
		return nil
	end

	-- 1. 如果整段文本去首尾空格后本身是合法 JSON
	local trimmed = text:match("^%s*(.-)%s*$")
	local ok, res = pcall(vim.json.decode, trimmed)
	if ok and type(res) == "table" then
		return trimmed
	end

	-- 2. 括号匹配提取所有候选 JSON 子串
	local candidates = {}
	local len = #text
	local stack = {}
	local in_str = false
	local escape = false

	for i = 1, len do
		local char = text:sub(i, i)
		if in_str then
			if escape then
				escape = false
			elseif char == "\\" then
				escape = true
			elseif char == '"' then
				in_str = false
			end
		else
			if char == '"' then
				in_str = true
			elseif char == "{" or char == "[" then
				table.insert(stack, { char = char, start_idx = i })
			elseif char == "}" or char == "]" then
				if #stack > 0 then
					local top = stack[#stack]
					if (top.char == "{" and char == "}") or (top.char == "[" and char == "]") then
						table.remove(stack)
						local start_idx = top.start_idx
						local sub = text:sub(start_idx, i)
						local ok_sub, sub_res = pcall(vim.json.decode, sub)
						if ok_sub and type(sub_res) == "table" then
							table.insert(candidates, { start_idx = start_idx, end_idx = i, text = sub })
						end
					end
				end
			end
		end
	end

	if #candidates == 0 then
		local s = text:match("({.*})") or text:match("(%[.*%])")
		if s and pcall(vim.json.decode, s) then
			return s
		end
		return nil
	end

	if col then
		for i = #candidates, 1, -1 do
			local c = candidates[i]
			if col >= c.start_idx and col <= c.end_idx then
				return c.text
			end
		end
	end

	table.sort(candidates, function(a, b)
		return (a.end_idx - a.start_idx) > (b.end_idx - b.start_idx)
	end)
	return candidates[1].text
end

-- 获取当前选区文本
local function get_visual_selection()
	local _, ls, cs = unpack(vim.fn.getpos("'<"))
	local _, le, ce = unpack(vim.fn.getpos("'>"))
	if ls > le or (ls == le and cs > ce) then
		ls, le = le, ls
		cs, ce = ce, cs
	end
	local lines = vim.api.nvim_buf_get_lines(0, ls - 1, le, false)
	if #lines == 0 then
		return ""
	end
	if #lines == 1 then
		return string.sub(lines[1], cs, ce)
	end
	lines[1] = string.sub(lines[1], cs)
	lines[#lines] = string.sub(lines[#lines], 1, ce)
	return table.concat(lines, "\n")
end

-- 浮窗展示核心函数
function M.show_json_float(opts)
	opts = opts or {}
	local raw_text = nil
	local cursor_col = nil

	if opts.visual then
		raw_text = get_visual_selection()
	else
		raw_text = vim.api.nvim_get_current_line()
		local cursor = vim.api.nvim_win_get_cursor(0)
		cursor_col = cursor[2] + 1
	end

	if not raw_text or raw_text == "" then
		vim.notify("当前行内容为空", vim.log.levels.WARN, { title = "JSON Preview" })
		return
	end

	local json_str = M.extract_json(raw_text, cursor_col)
	if not json_str then
		vim.notify("未在当前行或选区中检测到合法的 JSON 内容", vim.log.levels.WARN, { title = "JSON Preview" })
		return
	end

	local formatted_lines = M.format_json(json_str)
	if #formatted_lines == 0 then
		vim.notify("JSON 解析为空", vim.log.levels.WARN, { title = "JSON Preview" })
		return
	end

	-- 创建浮窗缓冲区
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
	vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

	-- 计算窗口尺寸
	local total_columns = vim.o.columns
	local total_lines = vim.o.lines

	local max_content_width = 20
	for _, l in ipairs(formatted_lines) do
		if #l > max_content_width then
			max_content_width = #l
		end
	end

	local win_width = math.min(math.max(max_content_width + 4, 40), math.floor(total_columns * 0.85))
	local win_height = math.min(math.max(#formatted_lines, 3), math.floor(total_lines * 0.8))

	local row = math.floor((total_lines - win_height) / 2) - 1
	local col = math.floor((total_columns - win_width) / 2)

	local win_opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = math.max(row, 1),
		col = math.max(col, 1),
		style = "minimal",
		border = "rounded",
		title = " JSON Preview (q: 关闭 | y: 复制全部) ",
		title_pos = "center",
		zindex = 50,
	}

	local win = vim.api.nvim_open_win(buf, true, win_opts)
	vim.api.nvim_set_option_value("wrap", true, { win = win })
	vim.api.nvim_set_option_value("number", true, { win = win })
	vim.api.nvim_set_option_value("cursorline", true, { win = win })

	-- 缓冲区快捷键绑定
	local key_opts = { buffer = buf, silent = true, noremap = true }

	local function close_win()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	vim.keymap.set("n", "q", close_win, key_opts)
	vim.keymap.set("n", "<Esc>", close_win, key_opts)

	local function copy_all()
		local text_to_copy = table.concat(formatted_lines, "\n")
		vim.fn.setreg("+", text_to_copy)
		vim.fn.setreg('"', text_to_copy)
		vim.notify("已复制格式化 JSON 到剪贴板！", vim.log.levels.INFO, { title = "JSON Preview" })
	end
	vim.keymap.set("n", "y", copy_all, key_opts)
	vim.keymap.set("n", "yy", copy_all, key_opts)
	vim.keymap.set("n", "Y", copy_all, key_opts)
end

function M.setup(opts)
	local function run_preview(args)
		local is_visual = (args and args.range and args.range > 0)
		M.show_json_float({ visual = is_visual })
	end

	vim.api.nvim_create_user_command("JsonPreview", run_preview, {
		range = true,
		desc = "浮窗格式化显示当前行/选区的 JSON",
	})

	vim.api.nvim_create_user_command("JsonFloat", run_preview, {
		range = true,
		desc = "浮窗格式化显示当前行/选区的 JSON (别名)",
	})
end

return M
