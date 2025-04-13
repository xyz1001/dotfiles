return {
	{
		"williamboman/mason.nvim",
		config = true,
	},

	-- hightlight
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

	-- LSP
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>e", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "显示诊断列表" },
		},
		init = function()
			-- 配置诊断显示
			vim.diagnostic.config({
				virtual_text = true, -- 在行尾显示诊断信息
				signs = true, -- 在行号列显示诊断图标
				underline = true, -- 用下划线标注诊断位置
				update_in_insert = false, -- 是否在插入模式实时更新诊断
				severity_sort = true, -- 按严重程度排序
				float = {
					border = "rounded", -- 浮动窗口边框样式
					source = "always", -- 总是显示诊断来源
					header = "", -- 浮动窗口标题
					prefix = "", -- 每行诊断信息的前缀
				},
			})

			-- 配置诊断图标
			local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- 自动显示诊断浮动窗口
			vim.api.nvim_create_autocmd("CursorHold", {
				group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
				callback = function()
					vim.diagnostic.open_float(nil, { focus = false })
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf, noremap = true, silent = true }
					local function quickfix()
						vim.lsp.buf.code_action({
							filter = function(a)
								return a.isPreferred
							end,
							apply = true,
						})
					end

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>x", quickfix, opts)
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "lua_ls", "clangd", "jsonls", "cmake", "pyright" },
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				["clangd"] = function()
					local function get_clangd_cmd()
						local cmd = { "clangd" }
						local compile_commands = vim.fn.getcwd() .. "/compile_commands.json"

						if vim.fn.filereadable(compile_commands) == 1 then
							local content = vim.fn.readfile(compile_commands)
							local ok, json = pcall(vim.json.decode, table.concat(content))

							if ok and json and #json > 0 and json[1].command then
								local compiler = vim.split(json[1].command, " ")[1]
								-- 检查编译器路径是否包含交叉编译相关关键词
								if compiler:match("arm") then
									-- 替换编译器路径中的 gcc/g++ 为 *
									local query_driver = compiler:gsub("[gc]%+%+$", "*"):gsub("gcc$", "*")
									table.insert(cmd, "--query-driver=" .. query_driver)
								end
							end
						end

						return cmd
					end

					require("lspconfig").clangd.setup({
						on_attach = function(_, bufnr)
							vim.keymap.set(
								"n",
								"<leader>s",
								"<cmd>ClangdSwitchSourceHeader<cr>",
								{ buffer = bufnr, noremap = true, silent = true }
							)
						end,
						cmd = get_clangd_cmd(),
					})
				end,
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			},
		},
	},

	-- complement
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },

		version = "1.*",
		opts = {
			enabled = function()
				return not vim.tbl_contains({ "json", "markdown" }, vim.bo.filetype)
			end,
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			--cmdline.keymap.preset = 'cmdline',

			keymap = {
				preset = "super-tab",
				["<C-p>"] = {
					function(cmp)
						if cmp.is_visible() then
							return cmp.select_prev()
						elseif cmp.snippet_active() then
							return cmp.snippet_backward()
						else
							return cmp.show()
						end
					end,
				},
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = true },
			},

			sources = {
				default = { "copilot", "lsp", "snippets", "path", "buffer" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },

			cmdline = {
				keymap = {
					["<Tab>"] = { "show", "accept" },
				},
				completion = { menu = { auto_show = true } },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"SirVer/ultisnips",
		init = function()
			vim.g.UltiSnipsExpandTrigger = "<C-e>"
			vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
		end,
	},

	-- format
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				objc = { "clang-format" },
				objcpp = { "clang-format" },
				dart = { "dart_format" },
				python = { "autopep8" },
				json = { "jq" },
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
		"zapling/mason-conform.nvim",
		dependencies = { "stevearc/conform.nvim", "williamboman/mason.nvim" },
		opts = {
			ensure_installed = { "clang-format", "stylua", "dart-format", "autopep8", "jq" },
		},
	},

	-- lint
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				shell = { "shellcheck" },
				cmake = { "cmakelint" },
				lua = { "luacheck" },
				json = { "jsonlint" },
			}
		end,
	},
	{
		"rshkarin/mason-nvim-lint",
		dependencies = { "mason.nvim", "mfussenegger/nvim-lint" },
		build = function()
			if vim.fn.has("win32") == 1 then
				vim.fn.system("scoop install luacheck")
			end
		end,
		opts = {
			ensure_installed = {
				"cmakelint",
				"shellcheck",
				"jsonlint",
				vim.fn.has("win32") == 0 and "luacheck" or nil,
			},
			ignore_install = {
				vim.fn.has("win32") == 1 and "luacheck" or nil,
			},
		},
	},

	-- comment
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

	-- debug
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
				{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)
			vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "", linehl = "", numhl = "" })

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
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
		opts = {
			ensure_installed = { "cpptools" },
		},
	},
}
