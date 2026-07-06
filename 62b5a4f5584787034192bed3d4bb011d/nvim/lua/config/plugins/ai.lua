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
		"aweis89/ai-terminals.nvim",
		dependencies = {
			{
				"folke/snacks.nvim",
				opts = function(_, opts)
					opts.terminal = vim.tbl_deep_extend("force", opts.terminal or {}, {
						win = {
							position = "right",
							enter = false,
						},
					})

					local sa = require("ai-terminals.snacks_actions")
					return sa.apply(opts)
				end,
			},
		},
		opts = {
			backend = "snacks",
			window_dimensions = {
				right = { width = 1 / 3, height = 0.5 },
			},
			terminals = {
				opencode = { cmd = "opencode" },
				agy = { cmd = "agy" },
			},
		},
		config = function(_, opts)
			local ai = require("ai-terminals")
			ai.setup(opts)

			local active_ai_terminal = nil
			local active_ai_terminal_buf = nil
			local prompt_history = {}
			local draft_input = nil

			local function clear_inactive_ai_terminal()
				if not active_ai_terminal_buf or not vim.api.nvim_buf_is_valid(active_ai_terminal_buf) then
					active_ai_terminal = nil
					active_ai_terminal_buf = nil
					return
				end

				local job_id = vim.b[active_ai_terminal_buf].terminal_job_id
				if not job_id or vim.fn.jobwait({ job_id }, 0)[1] ~= -1 then
					active_ai_terminal = nil
					active_ai_terminal_buf = nil
				end
			end

			local function toggle_ai_terminal(name)
				clear_inactive_ai_terminal()

				if active_ai_terminal and active_ai_terminal ~= name then
					vim.notify(
						string.format("%s is already running. Close it before starting %s.", active_ai_terminal, name),
						vim.log.levels.ERROR
					)
					return
				end

				local terminal = ai.toggle(name)
				if terminal and terminal.buf then
					active_ai_terminal = name
					active_ai_terminal_buf = terminal.buf
				end
			end

			local function get_file_reference_for_selection()
				local path = vim.fn.expand("%:p")
				if path == "" then
					return nil
				end

				local start_line = math.min(vim.fn.line("v"), vim.fn.line("."))
				local end_line = math.max(vim.fn.line("v"), vim.fn.line("."))
				if start_line == end_line then
					return string.format("%s:%d", path, start_line)
				end
				return string.format("%s:%d-%d", path, start_line, end_line)
			end

			local function get_visual_selection_context()
				local reference = get_file_reference_for_selection()
				if not reference then
					return nil
				end

				return reference .. "\n"
			end

			local function get_normal_mode_context()
				local path = vim.fn.expand("%:p")
				if path == "" then
					return nil
				end

				return path .. "\n"
			end

			local function open_ai_prompt_input(initial_text)
				clear_inactive_ai_terminal()

				if not active_ai_terminal then
					vim.notify("Start opencode or agy before sending a prompt.", vim.log.levels.ERROR)
					return
				end

				local buf = vim.api.nvim_create_buf(false, true)
				vim.bo[buf].buftype = "nofile"
				vim.bo[buf].bufhidden = "wipe"
				vim.bo[buf].filetype = "markdown"
				vim.bo[buf].swapfile = false

				local width = math.floor(vim.o.columns * 0.6)
				local height = math.max(6, math.floor(vim.o.lines * 0.25))
				local win = vim.api.nvim_open_win(buf, true, {
					relative = "editor",
					row = math.floor((vim.o.lines - height) / 2),
					col = math.floor((vim.o.columns - width) / 2),
					width = width,
					height = height,
					style = "minimal",
					border = "rounded",
					title = " Send to " .. active_ai_terminal .. " ",
					title_pos = "center",
				})

				local initial = initial_text
				if not initial or initial == "" then
					initial = draft_input or get_normal_mode_context()
				end

				if initial and initial ~= "" then
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(initial, "\n", { plain = true }))
					vim.api.nvim_win_set_cursor(win, { vim.api.nvim_buf_line_count(buf), 0 })
				end

				local function close_input()
					if vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_close(win, true)
					end
				end

				local history_idx = #prompt_history + 1
				local temp_input = nil
				local was_sent = false

				vim.api.nvim_create_autocmd("BufWipeout", {
					buffer = buf,
					callback = function()
						if not was_sent then
							local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
							local content = table.concat(lines, "\n")
							if content:gsub("^%s+", ""):gsub("%s+$", "") ~= "" then
								draft_input = content
							else
								draft_input = nil
							end
						else
							draft_input = nil
						end
					end,
				})

				local function set_buf_content(text)
					vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n", { plain = true }))
					local line_count = vim.api.nvim_buf_line_count(buf)
					local last_line = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1] or ""
					pcall(vim.api.nvim_win_set_cursor, win, { line_count, #last_line })
				end

				local function send_prompt()
					local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
					local prompt = table.concat(lines, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
					if prompt == "" then
						vim.notify("Prompt is empty.", vim.log.levels.WARN)
						return
					end

					if #prompt_history == 0 or prompt_history[#prompt_history] ~= prompt then
						table.insert(prompt_history, prompt)
						if #prompt_history > 5 then
							table.remove(prompt_history, 1)
						end
					end

					clear_inactive_ai_terminal()
					local target = active_ai_terminal
					if not target then
						vim.notify("The active AI terminal has exited.", vim.log.levels.ERROR)
						close_input()
						return
					end

					local job_id = vim.b[active_ai_terminal_buf].terminal_job_id
					if not job_id then
						vim.notify("The active AI terminal has no running job.", vim.log.levels.ERROR)
						close_input()
						return
					end

					local text_to_send = prompt
					if prompt:find("\n") then
						text_to_send = "\27[200~" .. prompt .. "\27[201~"
					end

					was_sent = true
					close_input()
					vim.fn.chansend(job_id, text_to_send)
					vim.fn.chansend(job_id, "\r")
				end

				vim.keymap.set({ "n", "i" }, "<C-s>", send_prompt, { buffer = buf, desc = "Send prompt" })
				vim.keymap.set("n", "<CR>", send_prompt, { buffer = buf, desc = "Send prompt" })
				vim.keymap.set("n", "<Esc>", close_input, { buffer = buf, desc = "Cancel prompt" })
				vim.keymap.set("n", "q", close_input, { buffer = buf, desc = "Cancel prompt" })

				vim.keymap.set("n", "<C-k>", function()
					if #prompt_history == 0 then
						return
					end
					if history_idx > 1 then
						if history_idx == #prompt_history + 1 then
							local current_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
							temp_input = table.concat(current_lines, "\n")
						end
						history_idx = history_idx - 1
						set_buf_content(prompt_history[history_idx])
					end
				end, { buffer = buf, desc = "Previous prompt history" })

				vim.keymap.set("n", "<C-j>", function()
					if #prompt_history == 0 then
						return
					end
					if history_idx < #prompt_history + 1 then
						history_idx = history_idx + 1
						if history_idx == #prompt_history + 1 then
							set_buf_content(temp_input or "")
						else
							set_buf_content(prompt_history[history_idx])
						end
					end
				end, { buffer = buf, desc = "Next prompt history" })
				vim.cmd.startinsert()
			end

			vim.api.nvim_create_autocmd("TermClose", {
				callback = function(event)
					if event.buf == active_ai_terminal_buf then
						active_ai_terminal = nil
						active_ai_terminal_buf = nil
					end
				end,
			})

			vim.keymap.set({ "n", "x" }, "<leader>ao", function()
				toggle_ai_terminal("opencode")
			end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "<leader>aa", function()
				toggle_ai_terminal("agy")
			end, { desc = "Toggle agy" })

			vim.keymap.set("n", "<leader>ai", function()
				open_ai_prompt_input(nil)
			end, { desc = "Send prompt to active AI" })

			vim.keymap.set("x", "<leader>ai", function()
				local context = get_visual_selection_context()
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
				vim.schedule(function()
					open_ai_prompt_input(context)
				end)
			end, { desc = "Send selection prompt to active AI" })

			-- Window navigation in AI terminals
			vim.api.nvim_create_autocmd("TermOpen", {
				callback = function(event)
					if vim.bo[event.buf].filetype ~= "snacks_terminal" then
						return
					end

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
				end,
			})
		end,
	},
}
