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
			{ "<leader>e", "<cmd>lua vim.diagnostic.setloclist()<cr>" },
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

	-- complement
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
		opts = {
			ensure_installed = { "cmakelint", "shellcheck", "jsonlint", "luacheck" },
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
}
