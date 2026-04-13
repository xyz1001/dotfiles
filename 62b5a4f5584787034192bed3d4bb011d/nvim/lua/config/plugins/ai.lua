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
			local win_opts = {
				split = "right",
				width = math.floor(vim.o.columns * 0.4),
			}

			vim.g.opencode_opts = {
				server = {
					port = port,
				},
			}

			local config = require("opencode.config")
			config.opts.server.start = function()
				require("opencode.terminal").open(cmd, win_opts)
			end
			config.opts.server.stop = function()
				require("opencode.terminal").close()
			end
			config.opts.server.toggle = function()
				require("opencode.terminal").toggle(cmd, win_opts)
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

						vim.api.nvim_create_autocmd("BufEnter", {
							buffer = event.buf,
							callback = function()
								vim.cmd.startinsert()
							end,
						})
					end
				end,
			})

			vim.keymap.set({ "n", "x" }, "<leader>oa", function()
				local opencode = require("opencode")

				-- 1. Check if window is already visible
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					if vim.api.nvim_buf_get_name(buf):find("opencode") then
						opencode.ask(" @buffer", { submit = true })
						return
					end
				end

				-- 2. Check if buffer exists but is hidden (toggled off)
				local opencode_buf_exists = false
				for _, buf in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf):find("opencode") then
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
						opencode.ask(" @buffer", { submit = true })
					end)
					return
				end

				-- 3. If no buffer existed, this is a fresh start. Show session selector.
				-- Custom logic to select session then ask
				require("opencode.server")
					.get()
					:next(function(server)
						server:get_sessions(function(sessions)
							if not sessions or #sessions == 0 then
								vim.schedule(function()
									opencode.ask(" @buffer ", { submit = true })
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
									return item.title or "Untitled"
								end,
							}, function(choice)
								if choice then
									if choice.id ~= "new" then
										server:select_session(choice.id)
									end
									vim.schedule(function()
										opencode.ask("@buffer ", { submit = true })
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
		end,
	},
}
