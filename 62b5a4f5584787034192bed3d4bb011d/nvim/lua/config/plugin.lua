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
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
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
		"rhysd/committia.vim",
		ft = "gitcommit",
		init = function()
			vim.g.floaterm_autoclose = 1
			vim.g.floaterm_autoinsert = 1
			vim.g.floaterm_keymap_toggle = "<c-t>"
		end,
	},
	{
		"Valloric/ListToggle",
		event = { "VeryLazy" },
	},
	{
		"voldikss/vim-floaterm",
		init = function()
			vim.g.committia_open_only_vim_starting = 1
		end,
	},
	{
		"chrisbra/Recover.vim",
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>" },
			{ "<leader>fs", "<cmd>Telescope grep_string<cr>" },
			{ "<leader>fy", "<cmd>Telescope registers<cr>" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>" },
		},
	},
	{
		"bronson/vim-trailing-whitespace",
		cmd = { "FixWhitespace" },
	},
	{
		"lilydjwg/fcitx.vim",
		enabled = vim.fn.has("x11") ~= 0,
	},
	{
		"google/vim-searchindex",
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
		"nvim-neo-tree/neo-tree.nvim",
		branch = "main",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
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
						["oa"] = "avante_add_files",
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
							require("avante.api").ask()
							sidebar = require("avante").get()
						end

						sidebar.file_selector:add_selected_file(relative_path)

						-- 删除 neo tree 缓冲区
						if not open then
							sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
						end
					end,
				},
			},
		},
		keys = {
			{ "<leader>n", "<cmd>Neotree toggle<cr>" },
		},
	},
	{
		"vim-scripts/ReplaceWithRegister",
	},
	{
		"vim-scripts/VisIncr",
	},
	{
		"voldikss/vim-translator",
		keys = {
			{ "<C-t>", "<Plug>TranslateWV", mode = { "v" } },
		},
	},
	{
		"hedyhli/markdown-toc.nvim",
		ft = "markdown",
		cmd = { "Mtoc" },
		config = true,
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
		"lewis6991/gitsigns.nvim",
		config = true,
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
		"lambdalisue/suda.vim",
		enabled = vim.fn.has("unix") ~= 0,
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
		"psliwka/vim-smoothie",
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
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
		keys = {
			{ "<leader>a", "<cmd>AerialToggle!<CR>" },
		},
	},
	{
		"voldikss/vim-browser-search",
		keys = {
			{ "<leader>gg", "<Plug>SearchNormal" },
			{ "<leader>gg", "<Plug>SearchVisual", mode = { "v" } },
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
		"neoclide/coc.nvim",
		build = "npm ci",
		lazy = false,
		config = function()
			vim.g.coc_global_extensions = {
				"coc-yank",
				"coc-html",
				"coc-lists",
				"coc-floaterm",
				"coc-diagnostic",
				"coc-clang-format-style-options",
				"coc-vimlsp",
				"coc-sh",
				"coc-pyright",
				"coc-json",
				"coc-cmake",
				"coc-clangd",
				"coc-snippets",
			}

			function _G.check_back_space()
				local col = vim.fn.col(".") - 1
				return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
			end
			function _G.show_docs()
				local cw = vim.fn.expand("<cword>")
				if vim.fn.index({ "vim", "help" }, vim.bo.filetype) >= 0 then
					vim.api.nvim_command("h " .. cw)
				elseif vim.api.nvim_eval("coc#rpc#ready()") then
					vim.fn.CocActionAsync("doHover")
				else
					vim.api.nvim_command("!" .. vim.o.keywordprg .. " " .. cw)
				end
			end

			local keyset = vim.keymap.set
			local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
			keyset(
				"i",
				"<TAB>",
				'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
				opts
			)
			keyset(
				"i",
				"<cr>",
				[[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
				opts
			)

			---@diagnostic disable-next-line: redefined-local
			local opts = { silent = true, noremap = true }
			keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
			keyset("n", "gy", "<plug>(coc-type-definition)", { silent = true })
			keyset("n", "gi", "<plug>(coc-implementation)", { silent = true })
			keyset("n", "K", "<CMD>lua _G.show_docs()<CR>", { silent = true })
			keyset("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true })
			keyset("n", "<leader>x", "<Plug>(coc-fix-current)", opts)
			keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
			keyset("n", "<Leader>e", ":<C-u>CocList diagnostics<cr>", opts)
			keyset("n", "<Leader>s", ":CocCommand clangd.switchSourceHeader<cr>", opts)
			keyset("i", "<C-e>", "<Plug>(coc-snippets-expand)", opts)
			keyset("v", "<C-e>", "<Plug>(coc-snippets-select)", opts)

			vim.api.nvim_create_augroup("CocGroup", {})
			vim.api.nvim_create_autocmd("CursorHold", {
				group = "CocGroup",
				command = "silent call CocActionAsync('highlight')",
				desc = "Highlight symbol under cursor on CursorHold",
			})
			vim.api.nvim_create_autocmd("User", {
				group = "CocGroup",
				pattern = "CocJumpPlaceholder",
				command = "call CocActionAsync('showSignatureHelp')",
				desc = "Update signature help on jump placeholder",
			})
		end,
	},
	{
		"github/copilot.vim",
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = {
			show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
			debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
			disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
			language = "Chinese", -- Copilot answer language settings when using default prompts. Default language is English.
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
		keys = {
			{ "<leader>ccb", ":CopilotChatBuffer ", desc = "CopilotChat - Chat with current buffer" },
			{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{
				"<leader>ccT",
				"<cmd>CopilotChatVsplitToggle<cr>",
				desc = "CopilotChat - Toggle Vsplit", -- Toggle vertical split
			},
			{
				"<leader>ccv",
				":CopilotChatVisual ",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>ccx",
				":CopilotChatInPlace<cr>",
				mode = "x",
				desc = "CopilotChat - Run in-place code",
			},
			{
				"<leader>ccf",
				"<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
				desc = "CopilotChat - Fix diagnostic",
			},
			{
				"<leader>ccr",
				"<cmd>CopilotChatReset<cr>", -- Reset chat history and clear buffer.
				desc = "CopilotChat - Reset chat history and clear buffer",
			},
		},
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
		},
		build = "make",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- 以下依赖项是可选的，
			"echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
			"nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
			"hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
			"nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- 用于 providers='copilot'
			{
				-- 支持图像粘贴
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- 推荐设置
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- Windows 用户必需
						use_absolute_path = true,
					},
				},
			},
			{
				-- 如果您有 lazy=true，请确保正确设置
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"nvim-telescope/telescope-dap.nvim",
				config = function()
					require("telescope").load_extension("dap")
				end,
			},
		},
		event = "VeryLazy",
		keys = {
			{
				"<F5>",
				function()
					require("dap").continue()
				end,
				desc = "launch/continue gdb",
			},
			{
				"<F10>",
				function()
					require("dap").step_over()
				end,
				desc = "单步调试",
			},
			{
				"<F11>",
				function()
					require("dap").step_into()
				end,
				desc = "步入",
			},
			{
				"<F12>",
				function()
					require("dap").step_out()
				end,
				desc = "步出",
			},
			{
				"<C-F5>",
				function()
					require("dap").terminate()
				end,
				desc = "终止程序",
			},
			{
				"<Leader>b",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "添加/删除断点",
			},
			{
				"<Leader>B",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "添加条件断点",
			},
			{
				"<Leader>dm",
				function()
					require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
				end,
				desc = "添加日志断点",
			},
			{
				"<Leader>dr",
				function()
					require("dap").repl.open()
				end,
				desc = "打开调试器",
			},
			{
				"<Leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "运行上次调试",
			},
			{
				"<Leader>dh",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "显示悬停信息",
			},
			{
				"<Leader>dp",
				function()
					require("dap.ui.widgets").preview()
				end,
				desc = "预览变量",
			},
			{
				"<Leader>df",
				function()
					require("telescope").extensions.dap.frames({})
				end,
				desc = "查看堆栈",
			},
			{
				"<Leader>dt",
				function()
					local widgets = require("dap.ui.widgets")
					local my_sidebar = widgets.sidebar(widgets.threads)
					my_sidebar.open()
				end,
				desc = "查看线程",
			},
			{
				"<Leader>ds",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.centered_float(widgets.scopes)
				end,
				desc = "查看变量",
			},
			{
				"<Leader>db",
				function()
					require("telescope").extensions.dap.list_breakpoints({})
				end,
				desc = "查看断点",
			},
			{
				-- 写在dapui中就会导致dap listener无法正常工作
				"<Leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "打开/关闭调试窗口",
			},
		},
		config = function()
			vim.api.nvim_set_hl(0, "DapStopped", {
				ctermbg = 0,
				fg = "#98c379",
				bg = "#31353f",
			})
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })

			local dap = require("dap")
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}
			dap.adapters.cppdbg = {
				id = "cppdbg",
				type = "executable",
				command = "/usr/share/cpptools-debug/bin/OpenDebugAD7",
			}
			dap.configurations.cpp = {
				{
					name = "Launch (vscode-cpptools)",
					type = "cppdbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtEntry = true,
					setupCommands = {
						{
							text = "-enable-pretty-printing",
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
				},
				{
					name = "Select and attach to process (vscode-cpptools)",
					type = "cppdbg",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
					setupCommands = {
						{
							text = "-enable-pretty-printing",
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
				},
				{
					name = "Attach to gdbserver :1234 (vscode-cpptools)",
					type = "cppdbg",
					request = "launch",
					MIMode = "gdb",
					miDebuggerServerAddress = "localhost:1234",
					miDebuggerPath = "/usr/bin/gdb",
					cwd = "${workspaceFolder}",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					setupCommands = {
						{
							text = "-enable-pretty-printing",
							description = "enable pretty printing",
							ignoreFailures = false,
						},
					},
				},
				{
					name = "Launch (gdb)",
					type = "gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Select and attach to process (gdb)",
					type = "gdb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to gdbserver :1234 (gdb)",
					type = "gdb",
					request = "attach",
					target = "localhost:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.c = dap.configurations.cpp
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		opts = {
			layouts = {
				{
					elements = {
						{
							id = "repl",
							size = 0.25,
						},
						{
							id = "stacks",
							size = 0.25,
						},
						{
							id = "watches",
							size = 0.25,
						},
						{
							id = "scopes",
							size = 0.25,
						},
					},
					position = "right",
					size = 80,
				},
				{
					elements = {
						{
							id = "console",
							size = 1,
						},
					},
					position = "bottom",
					size = 40,
				},
			},
		},
		config = function(_, opts)
			local dapui = require("dapui")
			dapui.setup(opts)

			local dap = require("dap")
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {},
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},

	-- nvim lsp 配置
	-- {
	-- 	"williamboman/mason.nvim",
	-- 	config = true,
	-- },
	-- {
	-- 	"williamboman/mason-lspconfig.nvim",
	-- 	opts = {
	-- 		ensure_installed = { "lua_ls", "clangd", "jsonls" },
	-- 		handlers = {
	-- 			function(server_name)
	-- 				require("lspconfig")[server_name].setup({})
	-- 			end,
	-- 			["clangd"] = function()
	-- 				require("lspconfig").clangd.setup({
	-- 					on_attach = function(_, bufnr)
	-- 						vim.keymap.set(
	-- 							"n",
	-- 							"<leader>s",
	-- 							"<cmd>ClangdSwitchSourceHeader<cr>",
	-- 							{ buffer = bufnr, noremap = true, silent = true }
	-- 						)
	-- 					end,
	-- 				})
	-- 			end,
	-- 			["lua_ls"] = function()
	-- 				require("lspconfig").lua_ls.setup({
	-- 					settings = {
	-- 						Lua = {
	-- 							diagnostics = {
	-- 								globals = { "vim" },
	-- 							},
	-- 						},
	-- 					},
	-- 				})
	-- 			end,
	-- 		},
	-- 	},
	-- },
	-- {
	-- 	"neovim/nvim-lspconfig",
	-- 	keys = {
	-- 		{ "<leader>e", "<cmd>lua vim.diagnostic.setloclist()<cr>" },
	-- 	},
	-- 	init = function()
	-- 		vim.api.nvim_create_autocmd("LspAttach", {
	-- 			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	-- 			callback = function(ev)
	-- 				vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
	--
	-- 				local opts = { buffer = ev.buf, noremap = true, silent = true }
	-- 				local function quickfix()
	-- 					vim.lsp.buf.code_action({
	-- 						filter = function(a)
	-- 							return a.isPreferred
	-- 						end,
	-- 						apply = true,
	-- 					})
	-- 				end
	--
	-- 				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	-- 				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	-- 				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- 				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	-- 				vim.keymap.set("n", "<leader>x", quickfix, opts)
	-- 				vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
	-- 				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	-- 				vim.keymap.set("n", "<leader>f", function()
	-- 					vim.lsp.buf.format({ async = true })
	-- 				end, opts)
	-- 			end,
	-- 		})
	-- 	end,
	-- },
	-- {
	--     "hrsh7th/nvim-cmp",
	--     event = "InsertEnter",
	--     dependencies = {
	--         "hrsh7th/cmp-nvim-lsp",
	--         "hrsh7th/cmp-buffer",
	--         "hrsh7th/cmp-path",
	--         "hrsh7th/cmp-cmdline",
	--         {
	--             "quangnguyen30192/cmp-nvim-ultisnips",
	--             config = true,
	--             dependencies = { "SirVer/ultisnips" },
	--         },
	--         {
	--             "saadparwaiz1/cmp_luasnip",
	--             dependencies = { "L3MON4D3/LuaSnip" },
	--         },
	--         {
	--             "chrisgrieser/cmp_yanky",
	--             dependencies = { "gbprod/yanky.nvim", opts = {} },
	--         },
	--         "paopaol/cmp-doxygen",
	--         {
	--             "hrsh7th/cmp-copilot",
	--             dependencies = { "github/copilot.vim" },
	--         },
	--     },
	--     opts = function()
	--         local cmp = require("cmp")
	--         return {
	--             completion = {
	--                 keyword_length = 2,
	--             },
	--             snippet = {
	--                 expand = function(args)
	--                     vim.fn["UltiSnips#Anon"](args.body)
	--                     require("luasnip").lsp_expand(args.body)
	--                 end,
	--             },
	--             window = {
	--                 completion = cmp.config.window.bordered(),
	--                 documentation = cmp.config.window.bordered(),
	--             },
	--             mapping = cmp.mapping.preset.insert({
	--                 ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
	--                 ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	--                 ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	--                 ["<C-f>"] = cmp.mapping.scroll_docs(4),
	--                 ["<CR>"] = cmp.mapping.confirm({ select = true }),
	--                 ["<Tab>"] = cmp.mapping(function(fallback)
	--                     if cmp.visible() then
	--                         cmp.select_next_item()
	--                     else
	--                         fallback()
	--                     end
	--                 end, { "i", "s" }),
	--             }),
	--             sources = cmp.config.sources({
	--                 { name = "copilot",  keyword_length = 0 },
	--                 { name = "nvim_lsp", trigger_characters = { ".", ">", ":", "/" } },
	--                 { name = "path" },
	--                 { name = "cmp_yanky" },
	--                 { name = "doxygen",  keyword_length = 1 },
	--                 { name = "ultisnips" },
	--                 { name = "luasnip" },
	--             }, {
	--                 { name = "buffer" },
	--             }),
	--             formatting = {
	--                 format = function(_, vim_item)
	--                     vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
	--                     return vim_item
	--                 end,
	--             },
	--         }
	--     end,
	-- },
	-- {
	--     "L3MON4D3/LuaSnip",
	--     dependencies = {
	--         {
	--             "rafamadriz/friendly-snippets",
	--             config = function()
	--                 require("luasnip.loaders.from_vscode").lazy_load()
	--             end,
	--         },
	--     },
	--     opts = {
	--         history = true,
	--         delete_check_events = "TextChanged",
	--     },
	--     keys = {
	--         {
	--             "<C-j>",
	--             function()
	--                 return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
	--             end,
	--             expr = true,
	--             silent = true,
	--             mode = "i",
	--         },
	--         {
	--             "<C-j>",
	--             function()
	--                 require("luasnip").jump(1)
	--             end,
	--             mode = "s",
	--         },
	--         {
	--             "<C-k>",
	--             function()
	--                 require("luasnip").jump(-1)
	--             end,
	--             mode = { "i", "s" },
	--         },
	--     },
	-- },
	-- {
	--     "SirVer/ultisnips",
	--     init = function()
	--         vim.g.UltiSnipsExpandTrigger = "<C-e>"
	--         vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
	--         vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
	--     end,
	-- },
})
