return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight-storm]])
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = true,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("alpha").setup(require("alpha.themes.startify").config)
		end,
	},
	{
		"f-person/git-blame.nvim",
		opts = {
			enabled = false,
		},
		cmd = { "GitBlameToggle" },
	},
	{
		"voldikss/vim-floaterm",
		init = function()
			vim.g.floaterm_autoclose = 1
			vim.g.floaterm_autoinsert = 1
			vim.g.floaterm_keymap_toggle = "<c-t>"
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>" },
			{ "<leader>fs", "<cmd>Telescope grep_string<cr>" },
			{ "<leader>fy", "<cmd>Telescope registers<cr>" },
			{ "<leader>fr", "<cmd>Telescope resume<cr>" },
		},
	},
	{
		"google/vim-searchindex",
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "main",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				window = {
					mappings = {
						["E"] = "system_open",
						["I"] = "run_command",
						["/"] = "",
						["z"] = "",
						["oa"] = "avante_add_files",
					},
				},
				commands = {
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						if vim.fn.has("macunix") ~= 0 then
							vim.fn.jobstart({ "open", path }, { detach = true })
						elseif vim.fn.has("win32") ~= 0 then
							vim.fn.jobstart({ "cmd", "/c", "explorer", path }, { detach = true })
						elseif vim.fn.has("unix") ~= 0 then
							vim.fn.jobstart({ "xdg-open", path }, { detach = true })
						end
					end,
					run_command = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.api.nvim_input(": " .. path .. "<Home>")
					end,
					avante_add_files = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local relative_path = require("avante.utils").relative_path(filepath)

						local sidebar = require("avante").get()

						local open = sidebar:is_open()
						-- 确保 avante 侧边栏已打开
						if not open then
							require("avante.api").ask()
							sidebar = require("avante").get()
						end

						sidebar.file_selector:add_selected_file(relative_path)

						-- 删除 neo tree 缓冲区
						if not open then
							sidebar.file_selector:remove_selected_file("neo-tree filesystem [1]")
						end
					end,
				},
			},
		},
		keys = {
			{ "<leader>n", "<cmd>Neotree toggle<cr>" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = true,
	},
	{
		"psliwka/vim-smoothie",
	},
	{
		"stevearc/aerial.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = true,
		keys = {
			{ "<leader>a", "<cmd>AerialToggle!<CR>" },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	{
		"weirongxu/plantuml-previewer.vim",
		dependencies = {
			"tyru/open-browser.vim",
		},
		cmd = { "PlantumlOpen", "PlantumlToggle" },
	},
}
