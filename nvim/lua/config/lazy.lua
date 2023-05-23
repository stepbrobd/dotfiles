local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		{
			"LazyVim/LazyVim",
			import = "lazyvim.plugins",
		},
		{ import = "lazyvim.plugins.extras.ui.mini-animate" },
		{ import = "plugins" },
	},

	-- Lazy Load
	defaults = {
		lazy = true,
	},

	-- Auto Install
	install = {
		missing = true,
		colorscheme = { "github_dimmed" },
	},

	-- Auto Reload Config
	change_detection = {
		enabled = true,
		notify = true,
	},

	-- Auto Update
	checker = {
		enabled = false,
		notify = false,
	},

	-- Performance
	performance = {
		cache = { enabled = true },
	},
})
