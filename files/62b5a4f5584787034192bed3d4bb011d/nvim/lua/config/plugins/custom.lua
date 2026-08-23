return {
	{
		"config/custom/json_preview",
		dir = vim.fn.stdpath("config") .. "/lua/config/custom",
		cmd = { "JsonPreview", "JsonFloat" },
		keys = {
			{
				"<leader>pj",
				"<cmd>JsonPreview<cr>",
				mode = { "n", "v" },
				desc = "浮窗格式化查看 JSON",
			},
			{
				"<leader>fj",
				"<cmd>JsonPreview<cr>",
				mode = { "n", "v" },
				desc = "浮窗格式化查看 JSON",
			},
			{
				"<leader>J",
				"<cmd>JsonPreview<cr>",
				mode = { "n", "v" },
				desc = "浮窗格式化查看 JSON",
			},
		},
		config = function()
			require("config.custom.json_preview").setup()
		end,
	},
}
