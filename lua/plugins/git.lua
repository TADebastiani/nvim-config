return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		config = function()
			require("gitsigns").setup()
		end,
		keys = {
			{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", desc = "Git preview Hunk" },
			{ "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Git Blame" },
		},
	},
}
