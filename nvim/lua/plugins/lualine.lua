return {
	"nvim-lualine/lualine.nvim",

	dependencies = { "nvim-tree/nvim-web-devicons", "github-nvim-theme" },

	opts = {
		options = {
			icons_enabled = true,
			theme = "auto",
			component_separators = {
				left = "",
				right = "",
			},
			section_separators = {
				left = "",
				right = "",
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = {},
			lualine_x = {},
			lualine_y = { "filetype", "encoding" },
			lualine_z = { "location" },
		},
	},
}
