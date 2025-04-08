return {
	--nvim lsp 配置
	{
		"williamboman/mason.nvim",
		config = true,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			ensure_installed = { "lua_ls", "clangd", "jsonls" },
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				["clangd"] = function()
					require("lspconfig").clangd.setup({
						on_attach = function(_, bufnr)
							vim.keymap.set(
								"n",
								"<leader>s",
								"<cmd>ClangdSwitchSourceHeader<cr>",
								{ buffer = bufnr, noremap = true, silent = true }
							)
						end,
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
	{
		"neovim/nvim-lspconfig",
		keys = {
			{ "<leader>e", "<cmd>lua vim.diagnostic.setloclist()<cr>" },
		},
		init = function()
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
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },

		version = "1.*",
		opts = {
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
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
}
