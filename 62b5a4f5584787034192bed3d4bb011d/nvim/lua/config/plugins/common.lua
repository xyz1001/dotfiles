return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-storm]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		"f-person/git-blame.nvim",
		opts = {
			enabled = false,
		},
		cmd = { "GitBlameToggle" },
	},
	{
		"voldikss/vim-floaterm",
		init = function()
			vim.g.floaterm_autoclose = 1
			vim.g.floaterm_autoinsert = 1
			vim.g.floaterm_keymap_toggle = "<c-t>"
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "查找文件" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "全局搜索" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "查找缓冲区" },
			{ "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "搜索当前单词" },
			{ "<leader>fy", "<cmd>Telescope registers<cr>", desc = "查看寄存器" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>", desc = "恢复上次搜索" },
		},
	},
	{
		"google/vim-searchindex",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "main",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
		},
		opts = {
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				window = {
					mappings = {
						["E"] = "system_open",
						["I"] = "run_command",
						["/"] = "",
						["z"] = "",
						["od"] = "vidir",
						["oa"] = "avante_add_files",
						["Y"] = "copy_filename",
					},
				},
				commands = {
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						if vim.fn.has("macunix") ~= 0 then
							vim.fn.jobstart({ "open", path }, { detach = true })
						elseif vim.fn.has("win32") ~= 0 then
							vim.fn.jobstart({ "cmd", "/c", "explorer", path }, { detach = true })
						elseif vim.fn.has("wsl") ~= 0 then
							vim.fn.jobstart({ "wsl-open", path }, { detach = true })
						elseif vim.fn.has("unix") ~= 0 then
							vim.fn.jobstart({ "xdg-open", path }, { detach = true })
						end
					end,
					run_command = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.api.nvim_input(": " .. path .. "<Home>")
					end,
					avante_add_files = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path = require("avante.utils").relative_path(filepath)

						local sidebar = require("avante").get()

						local open = sidebar:is_open()
						-- 确保 avante 侧边栏已打开
						if not open then
							-- 自动打开存在bug，如果neo-tree边栏关闭会导致avante也一起关闭，然后报错
							return
						end

						sidebar.file_selector:add_selected_file(relative_path)

						-- 删除 neo tree 缓冲区
						if not open then
							sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
						end
					end,
					vidir = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						-- 如果是文件，则获取其所在目录
						if node.type == "file" then
							path = vim.fn.fnamemodify(path, ":h")
						end
						-- 使用 Oil Lua API 避免命令行解析问题
						require("oil").open(path)
					end,
					copy_filename = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local filename = node.name
						local modify = vim.fn.fnamemodify

						local results = {
							filename,
							modify(filepath, ":."),
							filepath,
						}

						vim.ui.select({
							"1. Filename: " .. results[3],
							"2. Path relative to CWD: " .. results[2],
							"3. Absolute path: " .. results[1],
						}, { prompt = "Choose to copy to clipboard:" }, function(choice)
							if choice then
								local i = tonumber(choice:sub(1, 1))
								local result = results[i]
								vim.fn.setreg('"', result)
								vim.notify("Copied: " .. result)
							end
						end)
					end,
				},
			},
		},
		keys = {
			{ "<leader>n", "<cmd>Neotree toggle<cr>", desc = "切换文件树" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"karb94/neoscroll.nvim",
		opts = {
			mappings = {
				"<C-u>",
				"<C-d>",
				"zz",
			},
		},
	},
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
		keys = {
			{ "<leader>ae", "<cmd>AerialToggle!<CR>", desc = "切换代码大纲" },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"weirongxu/plantuml-previewer.vim",
		dependencies = {
			"tyru/open-browser.vim",
		},
		cmd = { "PlantumlOpen", "PlantumlToggle" },
	},
	{
		"christoomey/vim-tmux-navigator",
		enabled = vim.fn.has("unix") ~= 0,
		cond = vim.env.TMUX,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "tmux 左窗口" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "tmux 下窗口" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "tmux 上窗口" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "tmux 右窗口" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "tmux 上个窗口" },
		},
	},
	{
		"rhysd/committia.vim",
		ft = "gitcommit",
		init = function()
			vim.g.committia_open_only_vim_starting = 1
		end,
	},
	{
		"Valloric/ListToggle",
		event = { "VeryLazy" },
	},
	{
		"chrisbra/Recover.vim",
	},
	{
		"JuanZoran/Trans.nvim",
		build = function()
			require("Trans").install()
		end,
		keys = {
			{ "<C-t>", "<Cmd>Translate<CR>", mode = { "v" }, desc = "翻译选中文本" },
		},
		dependencies = { "kkharji/sqlite.lua" },
		opts = {
			frontend = {
				default = {
					auto_play = false,
					animation = {
						open = false, -- 'fold', 'slid'
						close = false,
						interval = 0,
					},
				},
			},
		},
	},
	{
		"voldikss/vim-browser-search",
		keys = {
			{ "<leader>gg", "<Plug>SearchNormal", desc = "在浏览器中搜索" },
			{ "<leader>gg", "<Plug>SearchVisual", mode = { "v" }, desc = "在浏览器中搜索选中文本" },
		},
	},
	{
		"bronson/vim-trailing-whitespace",
		cmd = { "FixWhitespace" },
	},
	{ "echasnovski/mini.operators", version = "*", config = true },
	{
		"vim-scripts/VisIncr",
	},
	{
		"easymotion/vim-easymotion",
		init = function()
			vim.g.EasyMotion_do_mapping = 0
			vim.keymap.set({ "n", "v" }, "f", "<Plug>(easymotion-bd-f)", { silent = true })
			vim.keymap.set({ "n", "v" }, "<leader>j", "<Plug>(easymotion-j)", { silent = true })
			vim.keymap.set({ "n", "v" }, "<leader>k", "<Plug>(easymotion-k)", { silent = true })
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
		"kana/vim-textobj-indent",
		dependencies = {
			"kana/vim-textobj-user",
		},
	},
	{
		"junegunn/vim-easy-align",
		keys = {
			{ "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "快速对齐" },
		},
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
		"keaising/im-select.nvim",
		build = function()
			if vim.fn.has("win32") == 1 then
				vim.fn.system("scoop install im-select")
			elseif vim.fn.has("wsl") == 1 then
				vim.fn.system(
					"curl -o ~/.local/bin/im-select.exe https://github.com/daipeihust/im-select/raw/1.0.1/im-select-win/out/x64/im-select.exe && chmod +x ~/.local/bin/im-select.exe"
				)
			end
		end,
		config = function()
			require("im_select").setup({})
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
			"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {},
		version = "^1.0.0", -- optional: only update when a new 1.x version is released
	},
	{ "simeji/winresizer" },
	{
		"gbprod/yanky.nvim",
		opts = {},
	},
	{
		"johmsalas/text-case.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			require("textcase").setup({})
			require("telescope").load_extension("textcase")
		end,
		keys = {
			"ga", -- Default invocation prefix
			{ "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
		},
		cmd = {
			-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
			"Subs",
			"TextCaseOpenTelescope",
			"TextCaseOpenTelescopeQuickChange",
			"TextCaseOpenTelescopeLSPChange",
			"TextCaseStartReplacingCommand",
		},
		-- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
		-- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
		-- available after the first executing of it or after a keymap of text-case.nvim has been used.
		lazy = false,
	},
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
		end,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "Oil" },
	},
}
