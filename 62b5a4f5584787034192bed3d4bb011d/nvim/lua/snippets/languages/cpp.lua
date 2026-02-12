local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local utils = require("snippets.utils")

-- 辅助：获取同步类名的函数节点
local sync_class_name = function(arg_idx)
	return f(function(args)
		return args[1][1] or ""
	end, { arg_idx })
end

return {
	-- 1. 包含头文件
	s("inc", { t("#include <"), i(1, "iostream"), t(">"), i(0) }),
	s("Inc", { t('#include "'), i(1, "iostream"), t('"'), i(0) }),

	-- 2. Clang-format 控制
	s("foff", {
		t({ "// clang-format off", "" }),
		d(1, utils.get_visual, {}),
		t({ "", "// clang-format on" }),
	}),

	-- 3. 标准类定义 (cl)
	s("cl", {
		t("class "),
		d(1, utils.get_basename(utils.to_pascal_case)),
		t({ " {", "public:", "\t" }),
		sync_class_name(1),
		t("("),
		i(2, "arguments"),
		t({ ");", "\t~" }),
		sync_class_name(1),
		t({ "();", "", "\t" }),
		sync_class_name(1),
		t("(const "),
		sync_class_name(1),
		t({ " &) = delete;", "\t" }),
		sync_class_name(1),
		t(" &operator=(const "),
		sync_class_name(1),
		t({ " &) = delete;", "", "\t" }),
		sync_class_name(1),
		t("("),
		sync_class_name(1),
		t({ " &&) = default;", "\t" }),
		sync_class_name(1),
		t(" &operator=("),
		sync_class_name(1),
		t({ " &&) = default;", "", "public:", "", "private:", "", "};" }),
	}),

	-- 4. 虚类/接口定义 (vcl)
	s("vcl", {
		t("class I"),
		d(1, utils.get_basename(utils.to_pascal_case)),
		t({ " {", "public:", "\tvirtual ~" }),
		sync_class_name(1),
		t({ "() = default;", "", "public:", "", "};" }),
	}),

	-- 5. Qt: QWidget 类定义
	s("qwidget", {
		t({ "#include <memory>", "#include <" }),
		i(1, "QWidget"),
		t({ ">", "", "namespace Ui {", "class " }),
		sync_class_name(2),
		t({ ";", "} // namespace Ui", "", "class " }),
		d(2, utils.get_basename(utils.to_pascal_case)),
		t(" : public "),
		rep(1),
		t({ " {", "\tQ_OBJECT", "", "public:", "\texplicit " }),
		sync_class_name(2),
		t("(QWidget *parent = nullptr);", "\t~"),
		sync_class_name(2),
		t({ "() override;", "", "private:", "\tusing Super = " }),
		rep(1),
		t({ ";", "", "\tstd.unique_ptr<Ui::" }),
		sync_class_name(2),
		t({ "> ui_;", "", "private:", "\t" }),
		i(0, "/* data */"),
		t({ "", "};" }),
	}),

	-- 6. Qt: QWidget 实现
	s("qwidgeti", {
		t('#include "ui_'),
		d(1, utils.get_basename()),
		t({ '.h"', "", "" }),
		d(2, utils.get_basename(utils.to_pascal_case)),
		t("::"),
		rep(2),
		t({ "(QWidget *parent)", "\t\t: Super(parent), ui_(std::make_unique<Ui::" }),
		rep(2),
		t({ ">()) {", "\tui_->setupUi(this);", "}", "", "" }),
		rep(2),
		t("::~"),
		rep(2),
		t("() = default;"),
	}),

	-- 7. Namespace
	s("ns", {
		t("namespace "),
		i(1, "name"),
		t({ " {", "" }),
		i(2),
		t({ "", "", "}  // namespace " }),
		rep(1),
	}),

	-- 8. 循环与异常
	s("try", {
		t({ "try {", "\t" }),
		d(1, utils.get_visual, {}),
		t({ "", "} catch (" }),
		i(2, "std::exception& exc"),
		t({ ") {", "\t" }),
		i(3, "// TODO"),
		t({ "", "}" }),
	}),
	s("fore", {
		t("for (auto "),
		i(2, "&i"),
		t(" : "),
		i(1, "container"),
		t({ ") {", "\t" }),
		d(3, utils.get_visual, {}),
		t({ "", "}" }),
	}),

	-- 9. Log
	s("logt", { t('LOGT("'), i(1, "trace"), t('");') }),
	s("logd", { t('LOGD("'), i(1, "debug"), t('");') }),
	s("logi", { t('LOGI("'), i(1, "info"), t('");') }),
	s("logw", { t('LOGW("'), i(1, "warning"), t('");') }),
	s("loge", { t('LOGE("'), i(1, "error"), t('");') }),

	-- 10. 杂项
	s("todo", { t('#pragma message("'), i(1), t('")') }),
	s("cs", { t("const std::string &"), i(1, "str") }),
	s("sleep", { t("std::this_thread::sleep_for(std::chrono::seconds("), i(1, "2"), t("));") }),
	s("mv", { t("std::move("), d(1, utils.get_visual, {}), t(")") }),
}
