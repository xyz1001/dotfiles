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
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			{
				"quangnguyen30192/cmp-nvim-ultisnips",
				config = true,
				dependencies = { "SirVer/ultisnips" },
			},
			{
				"saadparwaiz1/cmp_luasnip",
				dependencies = { "L3MON4D3/LuaSnip" },
			},
			{
				"chrisgrieser/cmp_yanky",
				dependencies = { "gbprod/yanky.nvim", opts = {} },
			},
			"paopaol/cmp-doxygen",
			{
				"hrsh7th/cmp-copilot",
				dependencies = { "github/copilot.vim" },
			},
		},
		opts = function()
			local cmp = require("cmp")
			return {
				completion = {
					keyword_length = 2,
				},
				snippet = {
					expand = function(args)
						vim.fn["UltiSnips#Anon"](args.body)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "copilot", keyword_length = 0 },
					{ name = "nvim_lsp", trigger_characters = { ".", ">", ":", "/" } },
					{ name = "path" },
					{ name = "cmp_yanky" },
					{ name = "doxygen", keyword_length = 1 },
					{ name = "ultisnips" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
				formatting = {
					format = function(_, vim_item)
						vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
						return vim_item
					end,
				},
			}
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		keys = {
			{
				"<C-j>",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<C-j>",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"<C-k>",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
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
