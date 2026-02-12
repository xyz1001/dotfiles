local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local pkg = require("snippets.utils") -- 引用公共模块
local utils = require("snippets.utils")

return {
	-- 基础头部
	s("header", pkg.header_comment()),

	-- 头文件 (pragma once)
	s(
		"hh",
		vim.list_extend(pkg.header_comment(), {
			t({ "", "#pragma once", "", "" }),
		})
	),

	-- 源文件 (include self header)
	s(
		"sh",
		vim.list_extend(pkg.header_comment(), {
			t({ "", '#include "' }),
			d(1, utils.get_basename()),
			t({ '.h"', "", "" }),
		})
	),

	-- main 函数
	s("main", {
		t({ "int main() {", "\t" }),
		d(1, pkg.get_visual, {}),
		t({ "", "\treturn 0;", "}" }),
	}),

	-- fori 循环
	s("fori", {
		t("for ("),
		i(3, "size_t"),
		t(" "),
		i(2, "i"),
		t(" = 0; "),
		f(function(args)
			return args[1][1]
		end, { 2 }),
		t(" < "),
		i(1, "count"),
		t("; "),
		t("++"),
		f(function(args)
			return args[1][1]
		end, { 2 }),
		t({ ") {", "\t" }),
		d(4, pkg.get_visual, {}),
		t({ "", "}" }),
	}),
}
