if vim.g.vscode then
	return {}
end
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
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
		"nickjvandyke/opencode.nvim",
		dependencies = {
			---@module 'snacks'
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			local function get_random_port()
				math.randomseed(vim.fn.getpid())
				return math.random(49152, 65535)
			end

			local port = get_random_port()
			local cmd = "opencode --port " .. port
			local snacks_terminal_opts = {
				win = {
					position = "right",
					width = math.floor(vim.o.columns * 0.4),
					enter = true,
					on_win = function(win)
						require("opencode.terminal").setup(win.win)
					end,
				},
			}

			vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts or {}, {
				server = {
					port = port,
				},
			})

			local config = require("opencode.config")
			config.opts.server.start = function()
				require("snacks.terminal").open(cmd, snacks_terminal_opts)
			end
			config.opts.server.stop = function()
				require("snacks.terminal").get(cmd, snacks_terminal_opts):close()
			end
			config.opts.server.toggle = function()
				require("snacks.terminal").toggle(cmd, snacks_terminal_opts)
			end

			local function opencode_toggle_no_enter()
				local saved = snacks_terminal_opts.win.enter
				snacks_terminal_opts.win.enter = false
				require("snacks.terminal").toggle(cmd, snacks_terminal_opts)
				snacks_terminal_opts.win.enter = saved
			end

			-- Enable window navigation and ESC for Opencode
			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function(event)
					local is_opencode = vim.api.nvim_buf_get_name(event.buf):find("opencode") ~= nil

					if is_opencode then
						local function map_nav(lhs, direction)
							local map_info = vim.fn.maparg(lhs, "n", false, true)
							local rhs = map_info.rhs

							if rhs and rhs ~= "" then
								if rhs:lower():match("^:<c%-u>") then
									rhs = rhs:gsub("^:<[cC]%-[uU]>", "<Cmd>"):gsub("<[cC][rR]>$", "<CR>")
								elseif rhs:match("^:") then
									rhs = "<Cmd>" .. rhs:sub(2) .. "<CR>"
								else
									rhs = "<C-\\><C-n>" .. rhs
								end
								vim.keymap.set("t", lhs, rhs, { buffer = event.buf, silent = true })
							end
						end

						map_nav("<C-h>", "h")
						map_nav("<C-j>", "j")
						map_nav("<C-k>", "k")
						map_nav("<C-l>", "l")
						map_nav("<C-\\>", "p")

						-- Map C-u/C-d to PageUp/PageDown for scrolling output
						vim.keymap.set("t", "<C-u>", "<PageUp>", { buffer = event.buf, silent = true })
						vim.keymap.set("t", "<C-d>", "<PageDown>", { buffer = event.buf, silent = true })
					end
				end,
			})

			vim.keymap.set({ "n", "x" }, "<leader>oa", function()
				local opencode = require("opencode")
				local mode = vim.fn.mode()
				local context = (mode == "v" or mode == "V" or mode == "\22") and "@visible " or "@buffer "

				local opencode_buf_exists = false
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf):find("opencode") then
						opencode_buf_exists = true
						break
					end
				end

				if not opencode_buf_exists then
					opencode.toggle()
					return
				end

				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_buf_get_name(buf):find("opencode") then
						opencode.ask(context, { submit = true })
						return
					end
				end

				opencode_toggle_no_enter()
				vim.schedule(function()
					opencode.ask(context, { submit = true })
				end)
			end, { desc = "Ask opencode…" })

			vim.keymap.set({ "n", "x" }, "<leader>ot", function()
				require("opencode").toggle()
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "<leader>od", function()
				require("opencode").ask(" @this ", { submit = true })
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "<leader>os", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
		end,
	},
	{
		"cajames/copy-reference.nvim",
		opts = {},
		keys = {
			{ "<leader>cp", "<cmd>CopyReference<cr>", mode = { "n", "v" }, desc = "Copy reference to clipboard" },
		},
	},
}
