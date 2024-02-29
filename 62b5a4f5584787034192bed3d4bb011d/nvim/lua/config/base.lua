vim.opt.wrap = true
vim.opt.number = true
vim.opt.colorcolumn = '81'
vim.opt.errorformat = vim.opt.errorformat + '[%f:%l] -> %m,[%f:%l]:%m'
vim.opt.listchars = vim.opt.listchars + 'eol:¬'
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.foldlevel = 99
vim.opt.foldenable = false
vim.opt.suffixes = '.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class'
vim.opt.wildignore =
'*.o, *.obj, *~, *.exe, *.a, *.pdb, *.lib, *.so, *.dll, *.swp, *.egg, *.jar, *.class, *.pyc, *.pyo, *.bin, *.dex, *.zip, *.7z, *.rar, *.gz, *.tar, *.gzip, *.bz2, *.tgz, *.xz, *DS_Store*, *.ipch, *.gem, *.png, *.jpg, *.gif, *.bmp, *.tga, *.pcx, *.ppm, *.img, *.iso, *.so, *.swp, *.zip, */.Trash/**, *.pdf, *.dmg, */.rbenv/**, */.nx/**, *.app, *.git, .git, *.wav, *.mp3, *.ogg, *.pcm, *.mht, *.suo, *.sdf, *.jnlp, *.chm, *.epub, *.pdf, *.mobi, *.ttf, *.mp4, *.avi, *.flv, *.mov, *.mkv, *.swf, *.swc, *.ppt, *.pptx, *.docx, *.xlt, *.xls, *.xlsx, *.odt, *.wps, *.msi, *.crx, *.deb, *.vfd, *.apk, *.ipa, *.bin, *.msu, *.gba, *.sfc, *.078, *.nds, *.smd, *.smc, *.linux2, *.win32, *.darwin, *.freebsd, *.linux, *.android'
vim.opt.expandtab = true
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.cindent = true
vim.opt.cino = '(0,W4'
vim.opt.formatoptions = vim.opt.formatoptions + 'mB'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'utf-8,ucs-bom,gbk,gb18030,big5,latin1'
vim.opt.fileformat = 'unix'
vim.opt.fileformats = 'unix,dos'
vim.opt.winaltkeys = 'no'
vim.opt.mouse = 'a'
vim.opt.cmdheight = 2
vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupext = 'bak'
vim.opt.backupdir = vim.fn.stdpath('data') .. '/backup'
vim.opt.undofile = true

vim.g.mapleader = ' '
vim.api.nvim_set_keymap('', 'H', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', 'L', '$', { noremap = true, silent = true })
-- Alt+j/k 逻辑跳转下一行/上一行
vim.api.nvim_set_keymap('', '<m-j>', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('', '<m-k>', 'gk', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-j>', '<Down>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-k>', '<Up>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-l>', '<Right>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-a>', '<Home>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('c', '<C-e>', '<End>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Backspace>', ':nohl<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', '"+gp', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-p>', '"+gp', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-y>', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<c-a>', '<c-\\><c-n>', { noremap = true, silent = true })
-- ' 禁止*搜索自动跳至下一个
vim.api.nvim_set_keymap('n', '*', '*``', { noremap = true, silent = true })
if not vim.env.TMUX then
    vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
end
if vim.fn.has('win32') ~= 0 then
    vim.opt.shell = 'pwsh'
    vim.opt.shellpipe = '|'
    vim.opt.shellxquote = ''
    vim.opt.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command'
    vim.opt.shellredir = '| Out-File -Encoding UTF8'
end
-- ' 清空背景色，支持透明背景
-- autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
vim.filetype.add {
    extension = {
        qss = 'css',
        ts = 'xml',
        ui = 'xml',
        qrc = 'xml'
    }
}

vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
    desc = 'return cursor to where it was last time closing the file',
    pattern = '*',
    command = 'silent! normal! g`"zv',
})
