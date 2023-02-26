return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	opts = function()
		local dashboard = require("alpha.themes.dashboard")
		local logo = [[
  █████████   █████                       ███████████                     ███████████  ██████████  
 ███░░░░░███ ░░███                       ░░███░░░░░███                   ░░███░░░░░███░░███░░░░███ 
░███    ░░░  ███████    ██████  ████████  ░███    ░███ ████████   ██████  ░███    ░███ ░███   ░░███
░░█████████ ░░░███░    ███░░███░░███░░███ ░██████████ ░░███░░███ ███░░███ ░██████████  ░███    ░███
 ░░░░░░░░███  ░███    ░███████  ░███ ░███ ░███░░░░░███ ░███ ░░░ ░███ ░███ ░███░░░░░███ ░███    ░███
 ███    ░███  ░███ ███░███░░░   ░███ ░███ ░███    ░███ ░███     ░███ ░███ ░███    ░███ ░███    ███ 
░░█████████   ░░█████ ░░██████  ░███████  ███████████  █████    ░░██████  ███████████  ██████████  
 ░░░░░░░░░     ░░░░░   ░░░░░░   ░███░░░  ░░░░░░░░░░░  ░░░░░      ░░░░░░  ░░░░░░░░░░░  ░░░░░░░░░░   
                                ░███                                                               
                                █████                                                              
                               ░░░░░                                                               
    ]]

		dashboard.section.header.val = vim.split(logo, "\n")
		dashboard.section.buttons.val = {
			dashboard.button("c", " " .. " Config", ":Lazy<CR>"),
			dashboard.button("r", " " .. " Recent Files", ":Telescope oldfiles <CR>"),
			dashboard.button("n", " " .. " New File", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", " " .. " Find File", ":Telescope find_files <CR>"),
			dashboard.button("g", " " .. " Live Grep", ":Telescope live_grep <CR>"),
			dashboard.button("s", "勒" .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
			dashboard.button("q", " " .. " Quit", ":qa<CR>"),
		}
		for _, button in ipairs(dashboard.section.buttons.val) do
			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"
		end
		dashboard.section.footer.opts.hl = "Type"
		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"
		dashboard.opts.layout[1].val = 8
		return dashboard
	end,
	config = function(_, dashboard)
		if vim.o.filetype == "lazy" then
			vim.cmd.close()
			vim.api.nvim_create_autocmd("User", {
				pattern = "AlphaReady",
				callback = function()
					require("lazy").show()
				end,
			})
		end

		require("alpha").setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				local stats = require("lazy").stats()
				local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
				dashboard.section.footer.val = "⚡Loaded " .. stats.count .. " plugins in " .. ms .. "ms"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})
	end,
}
