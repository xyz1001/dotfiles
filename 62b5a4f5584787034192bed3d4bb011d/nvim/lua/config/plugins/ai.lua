return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4o-copilot",
			suggestion = { enabled = true, auto_trigger = true },
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
		config = function()
			local copilot_chat = require("CopilotChat")
			anwser_in_chinese = "Please anwser all questions in Chinese"
			local copilot_instructions = require("CopilotChat.config.prompts").COPILOT_INSTRUCTIONS.system_prompt
				.. anwser_in_chinese
			local copilot_explain = require("CopilotChat.config.prompts").COPILOT_EXPLAIN.system_prompt
				.. anwser_in_chinese
			local copilot_review = require("CopilotChat.config.prompts").COPILOT_REVIEW.system_prompt
				.. anwser_in_chinese
			copilot_chat.setup({
				show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
				debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
				disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
				model = "gemini-2.0-flash-001",
				vim.print(),
				system_prompt = copilot_instructions,
				prompts = {
					Explain = { prompt = "解释选中的代码", system_prompt = copilot_explain },
					Review = { prompt = "审查选中的代码", system_prompt = copilot_review },
					Fix = "这代代码中存在一个问题，请重写这段代码以修复bug",
					Optimize = "请优化选中的代码",
					Docs = "请以Doxygen格式为我的代码生成面向开发者的文档，注释以中文编写",
					Tests = "请为我的代码生成测试",
					FixDiagnostic = "请帮助解决以下文件中的诊断问题：",
					Commit = "请写一个符合 commitizen 约定的提交信息。确保标题最多 50 个字符，消息在 72 个字符处换行。将整个消息用 gitcommit 语言包装在代码块中。",
					CommitStaged = "请写一个符合 commitizen 约定的提交信息。确保标题最多 50 个字符，消息在 72 个字符处换行。将整个消息用 gitcommit 语言包装在代码块中。",
				},
			})
		end,
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
			providers = {
				copilot = {
					endpoint = "https://api.githubcopilot.com",
					model = "claude-3.5-sonnet",
					proxy = nil, -- [protocol://]host[:port] Use this proxy
					allow_insecure = false, -- Allow insecure server connections
					timeout = 30000, -- Timeout in milliseconds
					extra_request_body = {
						temperature = 0,
						max_tokens = 20480,
					},
				},
			},
			behaviour = {
				auto_suggestions = false,
				auto_focus_sidebar = false,
				use_cwd_as_project_root = true,
			},
			history = {
				max_tokens = 8192,
			},
			mappings = {
				sidebar = {
					remove_file = "-",
					add_file = "+",
					close = {},
				},
			},
			windows = {
				ask = {
					start_insert = false, -- Start insert mode when opening the ask window
				},
			},
		},
		build = vim.fn.has("win32") == 1
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
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
