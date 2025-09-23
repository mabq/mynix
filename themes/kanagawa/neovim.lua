return {
	-- { "rebelot/kanagawa.nvim" },
	-- {
	-- 	"LazyVim/LazyVim",
	-- 	opts = {
	-- 		colorscheme = "kanagawa",
	-- 	},
	-- },
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				overrides = function()
					return {
						FloatBorder = { bg = "none" }, -- remove float border background (Yazi).
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-wave")
		end,
	},
}
