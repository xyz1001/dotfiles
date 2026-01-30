local ls = require("luasnip")
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local sn = ls.snippet_node

local M = {}

-- 获取作者
M.get_author = function()
	local name = vim.fn.system("git config user.name"):gsub("\n", "")
	local email = vim.fn.system("git config user.email"):gsub("\n", "")
	if name ~= "" then
		return name .. " <" .. email .. ">"
	end
	return os.getenv("USER") or "Author"
end

-- 获取日期
M.get_date = function()
	return os.date("%Y-%m-%d %H:%M:%S")
end

-- 处理 Visual 选中逻辑
M.get_visual = function(_, parent)
	if parent and parent.snippet.env.SELECT_RAW and #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, { i(1, parent.snippet.env.SELECT_RAW) })
	end
	return sn(nil, { i(1) })
end

-- 头部注释模板（返回节点列表）
M.header_comment = function()
	return {
		t({ "/*", " * author: " }),
		f(M.get_author, {}),
		t({ "", " * created at: " }),
		f(M.get_date, {}),
		t({ "", " * coding: utf-8", " */", "" }),
	}
end

-- 工具：SnakeCase (my_file) -> PascalCase (MyFile)
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

-- 获取文件名（不含扩展名）
M.get_basename = function()
	return vim.fn.expand("%:t:r")
end

-- 处理 Visual 选中逻辑
M.get_visual = function(_, parent)
	if parent and parent.snippet.env.SELECT_RAW and #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, { i(1, parent.snippet.env.SELECT_RAW) })
	end
	return sn(nil, { i(1) })
end

return M
