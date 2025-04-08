return {
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
}
