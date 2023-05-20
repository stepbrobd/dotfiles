return {
	"nvim-tree/nvim-tree.lua",

	version = "*",

	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},

	enable = true,
	lazy = false,

	config = function()
		require("nvim-tree").setup({})
	end,
}
