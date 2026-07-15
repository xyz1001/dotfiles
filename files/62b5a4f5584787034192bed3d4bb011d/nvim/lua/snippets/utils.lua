local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

-- --- 缓存变量 ---
local cached_author = nil

-- 获取作者（带缓存逻辑）
M.get_author = function()
	-- 如果已经缓存过，直接返回结果，不再执行外部命令
	if cached_author then
		return cached_author
	end

	-- 第一次执行时，获取并存入缓存
	local name = vim.fn.system("git config user.name"):gsub("\n", "")
	local email = vim.fn.system("git config user.email"):gsub("\n", "")

	if name ~= "" then
		cached_author = name .. " <" .. email .. ">"
	else
		cached_author = os.getenv("USER") or "Author"
	end

	return cached_author
end

-- 获取日期（os.date 极快，无需缓存）
M.get_date = function()
	return os.date("%Y-%m-%d %H:%M:%S")
end

-- 转换 PascalCase
M.to_pascal_case = function(s)
	if not s or s == "" then
		return ""
	end
	local parts = vim.split(s, "_", { trimempty = true })
	for k, v in ipairs(parts) do
		parts[k] = v:sub(1, 1):upper() .. v:sub(2)
	end
	return table.concat(parts)
end

-- 获取文件名
M.get_basename = function(transform_fn)
	return function(_, snip)
		local name = snip.env.TM_FILENAME_BASE or ""

		if transform_fn then
			name = transform_fn(name)
		end

		return sn(nil, {
			i(1, name),
		})
	end
end

-- 处理 Visual 选中逻辑
M.get_visual = function(_, parent)
	if parent and parent.snippet.env.SELECT_RAW and #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, { i(1, parent.snippet.env.SELECT_RAW) })
	end
	return sn(nil, { i(1) })
end

-- 头部注释节点
M.header_comment = function()
	local t = ls.text_node
	local f = ls.function_node
	return {
		t({ "/*", " * author: " }),
		f(M.get_author, {}), -- 这里引用 get_author，它内部会自动处理缓存
		t({ "", " * created at: " }),
		f(M.get_date, {}),
		t({ "", " * coding: utf-8", " */", "" }),
	}
end

return M
