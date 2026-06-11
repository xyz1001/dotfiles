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
			local cmd = "opencode --port"
			local snacks_terminal_opts = {
				win = {
					position = "right",
					width = math.floor(vim.o.columns * 0.4),
					enter = false,
				},
			}

			vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts or {}, {
				server = {
					start = function()
						require("snacks.terminal").open(cmd, snacks_terminal_opts)
					end,
				},
			})

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
				local mode = vim.fn.mode()
				local context = (mode == "v" or mode == "V" or mode == "\22") and "@visible " or "@buffer "
				require("opencode").ask(context)
			end, { desc = "Ask opencode…" })

			vim.keymap.set({ "n", "t" }, "<C-.>", function()
				require("snacks.terminal").toggle(cmd, snacks_terminal_opts)
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "<leader>ot", function()
				require("snacks.terminal").toggle(cmd, snacks_terminal_opts)
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "<leader>od", function()
				require("opencode").prompt(" @this ")
			end, { desc = "Ask opencode with @this" })

			vim.keymap.set({ "n", "x" }, "<leader>os", function()
				require("opencode").select()
			end, { desc = "Execute opencode action…" })
		end,
	},
}
