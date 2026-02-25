if vim.g.vscode then
	return {}
end
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4.1",
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
			-- Function to get a free port to ensure Opencode isolation per nvim instance
			local function get_random_port()
				math.randomseed(vim.fn.getpid())
				return math.random(49152, 65535)
			end

			---@type opencode.Opts
			vim.g.opencode_opts = {
				port = get_random_port(),
				auto_reload = true,
				auto_focus = true,
				win = {
					position = "right",
					width = 0.4,
				},
			}

			-- Enable window navigation and ESC for Opencode
			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function(event)
					local is_opencode = vim.bo[event.buf].filetype == "opencode_terminal"

					if is_opencode then
						-- Function to dynamically read normal mode mapping and apply it to terminal mode
						-- This respects whatever is configured in normal mode (Tmux or native).
						local function map_nav(lhs, direction)
							local map_info = vim.fn.maparg(lhs, "n", false, true)
							local rhs = map_info.rhs

							if rhs and rhs ~= "" then
								-- Adapt command-line mappings (e.g. ":<C-U>Command<CR>") for Terminal mode ("<Cmd>Command<CR>")
								if rhs:lower():match("^:<c%-u>") then
									rhs = rhs:gsub("^:<[cC]%-[uU]>", "<Cmd>"):gsub("<[cC][rR]>$", "<CR>")
								elseif rhs:match("^:") then
									rhs = "<Cmd>" .. rhs:sub(2) .. "<CR>"
								end
								vim.keymap.set("t", lhs, rhs, { buffer = event.buf, silent = true })
							end
						end

						map_nav("<C-h>", "h")
						map_nav("<C-j>", "j")
						map_nav("<C-k>", "k")
						map_nav("<C-l>", "l")
						map_nav("<C-\\>", "p")

						-- Block Ctrl-D to prevent accidental terminal exit
						vim.keymap.set("t", "<C-d>", "<Nop>", { buffer = event.buf, silent = true })
					end
				end,
			})

			vim.keymap.set({ "n", "x" }, "<leader>oa", function()
				local opencode = require("opencode")

				-- 1. Check if window is already visible
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.bo[buf].filetype == "opencode_terminal" then
						opencode.ask(" @this", { submit = true })
						return -- Already focused and ready
					end
				end

				-- 2. Check if buffer exists but is hidden (toggled off)
				local opencode_buf_exists = false
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.bo[buf].filetype == "opencode_terminal" then
						opencode_buf_exists = true
						break
					end
				end

				-- Toggle window visible
				opencode.toggle()

				if opencode_buf_exists then
					-- If buffer existed, we just restored it. Skip session selection.
					-- Wait a bit for window to be ready
					vim.schedule(function()
						opencode.ask(" @this", { submit = true })
					end)
					return
				end

				-- 3. If no buffer existed, this is a fresh start. Show session selector.
				-- Custom logic to select session then ask
				local server_mod = require("opencode.cli.server")
				local client_mod = require("opencode.cli.client")

				server_mod
					.get()
					:next(function(server)
						return server.port
					end)
					:next(function(port)
						client_mod.get_sessions(port, function(sessions)
							if not sessions or #sessions == 0 then
								vim.schedule(function()
									opencode.ask(" @this ", { submit = true })
								end)
								return
							end

							table.sort(sessions, function(a, b)
								return a.time.updated > b.time.updated
							end)
							table.insert(sessions, 1, { id = "new", title = "New Session" })
							vim.ui.select(sessions, {
								prompt = "Select session:",
								format_item = function(item)
									local title = item.title or "Untitled"
									return title
								end,
							}, function(choice)
								if choice then
									if choice.id ~= "new" then
										client_mod.select_session(port, choice.id)
									end
									vim.schedule(function()
										opencode.ask("@this ", { submit = true })
									end)
								end
							end)
						end)
					end)
					:catch(function(err)
						vim.notify("Opencode error: " .. tostring(err), vim.log.levels.ERROR)
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

			-- Ensure Opencode process is killed when Neovim exits
			-- https://github.com/nickjvandyke/opencode.nvim/issues/174
			vim.api.nvim_create_autocmd("VimLeavePre", {
				callback = function()
					local ok, opencode = pcall(require, "opencode")
					if ok then
						pcall(opencode.stop)
					end

					if vim.fn.has("unix") == 1 then
						local pid = vim.fn.getpid()
						vim.fn.system({ "pkill", "-P", tostring(pid), "-f", "opencode" })
					end
				end,
			})
		end,
	},
}
