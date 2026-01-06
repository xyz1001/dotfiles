vim.opt.wrap = true
if not vim.g.vscode then
	vim.opt.number = true
	vim.opt.colorcolumn = "81"
	vim.opt.errorformat = vim.opt.errorformat + "[%f:%l] -> %m,[%f:%l]:%m"
	vim.opt.listchars = vim.opt.listchars + "eol:¬"
	vim.opt.cursorline = true
end
vim.opt.fixendofline = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldlevel = 99
vim.opt.foldenable = false
vim.opt.suffixes = ".bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class"
vim.opt.wildignore =
	"*.o, *.obj, *~, *.exe, *.a, *.pdb, *.lib, *.so, *.dll, *.swp, *.egg, *.jar, *.class, *.pyc, *.pyo, *.bin, *.dex, *.zip, *.7z, *.rar, *.gz, *.tar, *.gzip, *.bz2, *.tgz, *.xz, *DS_Store*, *.ipch, *.gem, *.png, *.jpg, *.gif, *.bmp, *.tga, *.pcx, *.ppm, *.img, *.iso, *.so, *.swp, *.zip, */.Trash/**, *.pdf, *.dmg, */.rbenv/**, */.nx/**, *.app, *.git, .git, *.wav, *.mp3, *.ogg, *.pcm, *.mht, *.suo, *.sdf, *.jnlp, *.chm, *.epub, *.pdf, *.mobi, *.ttf, *.mp4, *.avi, *.flv, *.mov, *.mkv, *.swf, *.swc, *.ppt, *.pptx, *.docx, *.xlt, *.xls, *.xlsx, *.odt, *.wps, *.msi, *.crx, *.deb, *.vfd, *.apk, *.ipa, *.bin, *.msu, *.gba, *.sfc, *.078, *.nds, *.smd, *.smc, *.linux2, *.win32, *.darwin, *.freebsd, *.linux, *.android"
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cindent = true
vim.opt.cino = "(0,W4"
vim.opt.formatoptions = vim.opt.formatoptions + "mB"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8,ucs-bom,gbk,gb18030,big5,latin1"
vim.opt.fileformat = "unix"
vim.opt.fileformats = "unix"
vim.opt.winaltkeys = "no"
vim.opt.mouse = "a"
vim.opt.cmdheight = 2
vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupext = "bak"
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.undofile = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"

vim.g.mapleader = " "
vim.keymap.set({ "", "v" }, "H", "^", { desc = "跳转至行首(不包含空格)" })
vim.keymap.set({ "", "v" }, "L", "$", { desc = "跳转至行尾" })
-- Alt+j/k 逻辑跳转下一行/上一行
vim.keymap.set({ "", "v" }, "<m-j>", "gj", { desc = "向下移动(支持自动换行)" })
vim.keymap.set({ "", "v" }, "<m-k>", "gk", { desc = "向上移动(支持自动换行)" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "命令模式向下" })
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "命令模式向上" })
vim.keymap.set("c", "<C-h>", "<Left>", { desc = "命令模式向左" })
vim.keymap.set("c", "<C-l>", "<Right>", { desc = "命令模式向右" })
vim.keymap.set("c", "<C-a>", "<Home>", { desc = "命令模式跳转行首" })
vim.keymap.set("c", "<C-e>", "<End>", { desc = "命令模式跳转行尾" })
vim.keymap.set("n", "<Backspace>", ":nohl<CR>", { desc = "清除搜索高亮" })
vim.keymap.set("n", "<C-p>", '"+gp', { desc = "从系统剪贴板粘贴" })
vim.keymap.set("v", "<C-p>", '"+gp', { desc = "从系统剪贴板粘贴" })
vim.keymap.set("v", "<C-y>", '"+y', { desc = "复制到系统剪贴板" })
vim.keymap.set("t", "<c-a>", "<c-\\><c-n>", { desc = "终端模式退出" })
-- 禁止*搜索自动跳至下一个
vim.keymap.set("n", "*", "*``", { desc = "搜索当前单词(不移动光标)" })
if not vim.env.TMUX then
	vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "跳转到下方窗口" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "跳转到上方窗口" })
	vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "跳转到左侧窗口" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "跳转到右侧窗口" })
end
if vim.fn.has("win32") ~= 0 then
	vim.opt.shell = "pwsh"
	vim.opt.shellpipe = "|"
	vim.opt.shellxquote = ""
	vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
	vim.opt.shellredir = "| Out-File -Encoding UTF8"
end
-- ' 清空背景色，支持透明背景
-- autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
vim.filetype.add({
	extension = {
		qss = "css",
		ts = "xml",
		ui = "xml",
		qrc = "xml",
	},
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	desc = "return cursor to where it was last time closing the file",
	pattern = "*",
	command = 'silent! normal! g`"zv',
})

-- Neovim 0.11添加了这些用于lsp
if vim.fn.has("nvim-0.11") == 1 then
	vim.keymap.del("n", "gra")
	vim.keymap.del("n", "gri")
	vim.keymap.del("n", "grn")
	vim.keymap.del("n", "grr")
end
