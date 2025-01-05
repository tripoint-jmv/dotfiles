return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
				italic_comments = true,
				italic_keywords = true,
				italic_functions = true,
				italic_variables = true,
				italic_constants = true,
				italic_builtins = true,
			})
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
