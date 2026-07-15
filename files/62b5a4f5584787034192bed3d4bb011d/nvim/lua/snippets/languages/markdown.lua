local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local utils = require("snippets.utils")

return {
	-- 1. TO BE DONE
	s("tbd", {
		t("== TO BE DONE == "),
		i(0),
	}),

	-- 2. 代码块 (支持 Visual 模式包裹内容)
	s("code", {
		t({ "```", "" }),
		d(1, utils.get_visual, {}),
		t({ "", "```" }),
	}),

	-- 3. More 标签 (通常用于博客摘要)
	s("more", {
		t("<!--more-->"),
	}),

	-- 4. 表格模板 (3x3)
	s("table", {
		t("| "),
		i(1),
		t(" | "),
		i(2),
		t(" | "),
		i(3),
		t({ " |", "|---|---|---|", "| " }),
		i(4),
		t(" | "),
		i(5),
		t(" | "),
		i(6),
		t({ " |", "| " }),
		i(7),
		t(" | "),
		i(8),
		t(" | "),
		i(9),
		t(" |"),
	}),

	s("link", {
		t("["),
		i(1, "text"),
		t("]("),
		i(2, "url"),
		t(")"),
		i(0),
	}),
}
