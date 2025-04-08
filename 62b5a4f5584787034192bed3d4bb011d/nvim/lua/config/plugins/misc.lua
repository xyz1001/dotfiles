return {
	{
		"christoomey/vim-tmux-navigator",
		enabled = vim.fn.has("unix") ~= 0,
		cond = vim.env.TMUX,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{
		"rhysd/committia.vim",
		ft = "gitcommit",
		init = function()
			vim.g.committia_open_only_vim_starting = 1
		end,
	},
	{
		"Valloric/ListToggle",
		event = { "VeryLazy" },
	},
	{
		"chrisbra/Recover.vim",
	},
	{
		"voldikss/vim-translator",
		keys = {
			{ "<C-t>", "<Plug>TranslateWV", mode = { "v" } },
		},
	},
	{
		"voldikss/vim-browser-search",
		keys = {
			{ "<leader>gg", "<Plug>SearchNormal" },
			{ "<leader>gg", "<Plug>SearchVisual", mode = { "v" } },
		},
	},
}
