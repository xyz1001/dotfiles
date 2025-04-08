local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local output = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
	print(output)
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	require("config.plugins.view"),
	require("config.plugins.edit"),
	require("config.plugins.coc"),
	--require("config.plugins.lsp"),
	require("config.plugins.ai"),
	require("config.plugins.debug"),
	require("config.plugins.misc"),
})
