return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4o-copilot",
			suggestion = { enabled = false, auto_trigger = true },
			panel = { enabled = false },
		},
		config = true,
	},
	{
		"AndreM222/copilot-lualine",
		config = function()
			current = require("lualine").get_config()
			table.insert(current.sections.lualine_x, 1, "copilot")
			require("lualine").setup(current)
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = {
			show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
			debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
			disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
			language = "Chinese", -- Copilot answer language settings when using default prompts. Default language is English.
			model = "gemini-2.0-flash-001",
			prompts = {
				Explain = "请解释选中的代码",
				Review = "审查选中的代码",
				Fix = "这代代码中存在一个问题，请重写这段代码以修复bug",
				Optimize = "请优化选中的代码",
				Docs = "请为我的代码生成文档",
				Tests = "请为我的代码生成测试",
				FixDiagnostic = "请帮助解决以下文件中的诊断问题：",
				Commit = "请写一个符合 commitizen 约定的提交信息。确保标题最多 50 个字符，消息在 72 个字符处换行。将整个消息用 gitcommit 语言包装在代码块中。",
				CommitStaged = "请写一个符合 commitizen 约定的提交信息。确保标题最多 50 个字符，消息在 72 个字符处换行。将整个消息用 gitcommit 语言包装在代码块中。",
			},
		},
		build = function()
			vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
		end,
		event = "VeryLazy",
	},
	{
		"folke/edgy.nvim",
		event = "VeryLazy",
		opts = {
			right = {
				{
					title = "CopilotChat.nvim", -- Title of the window
					ft = "copilot-chat", -- This is custom file type from CopilotChat.nvim
					size = { width = 0.4 }, -- Width of the window
				},
			},
		},
	},
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		opts = {
			provider = "copilot",
			copilot = {
				endpoint = "https://api.githubcopilot.com",
				model = "claude-3.5-sonnet",
				proxy = nil, -- [protocol://]host[:port] Use this proxy
				allow_insecure = false, -- Allow insecure server connections
				timeout = 30000, -- Timeout in milliseconds
				temperature = 0,
				max_tokens = 20480,
			},
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"echasnovski/mini.pick",
			"nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
			"nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
			"zbirenbaum/copilot.lua",
		},
	},
}
