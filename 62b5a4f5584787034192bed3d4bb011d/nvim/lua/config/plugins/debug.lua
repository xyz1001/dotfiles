return {
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
}
