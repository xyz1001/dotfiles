return {
	{
		"bronson/vim-trailing-whitespace",
		cmd = { "FixWhitespace" },
	},
	{
		"vim-scripts/ReplaceWithRegister",
	},
	{
		"vim-scripts/VisIncr",
	},
	{
		"easymotion/vim-easymotion",
		init = function()
			vim.g.EasyMotion_do_mapping = 0
			vim.keymap.set("n", "<leader>j", "<Plug>(easymotion-j)", { silent = true })
			vim.keymap.set("n", "<leader>k", "<Plug>(easymotion-k)", { silent = true })
		end,
	},
	{
		"tpope/vim-repeat",
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = true,
	},
	{
		"dyng/ctrlsf.vim",
	},
	{
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_theme = "olive"
			vim.g.VM_leader = "\\"
			vim.g.VM_maps = { ["Select All"] = "\\a" }
		end,
	},
	{
		"simnalamburt/vim-mundo",
	},
	{
		"AndrewRadev/splitjoin.vim",
	},
	{
		"numToStr/Comment.nvim",
		config = true,
		lazy = false,
		opts = {
			padding = false,
		},
	},
	{
		"vim-scripts/DoxygenToolkit.vim",
		init = function()
			vim.g.DoxygenToolkit_briefTag_pre = "@brief "
			vim.g.DoxygenToolkit_paramTag_pre = "@param "
			vim.g.DoxygenToolkit_returnTag = "@returns "
		end,
		cmd = { "Dox" },
	},
	{
		"kana/vim-textobj-indent",
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "n", "x" } },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "VeryLazy" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		opts = {
			ensure_installed = {
				"c",
				"cpp",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"css",
				"html",
				"bash",
				"cmake",
				"csv",
				"git_config",
				"gitignore",
				"glsl",
				"hlsl",
				"json",
				"make",
				"ninja",
				"qmljs",
				"regex",
				"ssh_config",
				"tmux",
				"xml",
				"yaml",
				"diff",
				"javascript",
				"markdown",
				"markdown_inline",
				"python",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				disable = function(lang, buf)
					local max_filesize = 100 * 1024
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
				additional_vim_regex_highlighting = false,
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function(_, opts)
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["a,"] = "@parameter.outer",
							["i,"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["a/"] = "@comment.outer",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner" },
							["as"] = { query = "@scope", query_group = "locals" },
						},
						selection_modes = {
							["@parameter.outer"] = "v",
							["@function.outer"] = "V",
							["@class.outer"] = "V",
						},
						include_surrounding_whitespace = false,
					},
					swap = {
						enable = true,
						swap_previous = {
							["<leader>S"] = "@parameter.inner",
						},
					},
				},
			})
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				objc = { "clang_format" },
				objcpp = { "clang_format" },
				dart = { "dart_format" },
				python = { "autopep8" },
			},
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat then
					return
				end
				return { timeout_ms = 500, lsp_fallback = true }
			end,
		},
		init = function()
			vim.api.nvim_create_user_command("ToggleFormat", function(args)
				vim.g.disable_autoformat = not vim.g.disable_autoformat
			end, {
				desc = "toggle autoformat-on-save",
			})
		end,
	},
	{
		"hedyhli/markdown-toc.nvim",
		ft = "markdown",
		cmd = { "Mtoc" },
		config = true,
	},
	{
		"lambdalisue/suda.vim",
		enabled = vim.fn.has("unix") ~= 0,
	},
	{
		"lilydjwg/fcitx.vim",
		enabled = vim.fn.executable("fcitx5") ~= 0,
	},
}
