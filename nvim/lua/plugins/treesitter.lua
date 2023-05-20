return {
	{
		"nvim-treesitter/nvim-treesitter",

		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },

		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
					local opts = require("lazy.core.plugin").values(plugin, "opts", false)
					local enabled = false
					if opts.textobjects then
						for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
							if opts.textobjects[mod] and opts.textobjects[mod].enable then
								enabled = true
								break
							end
						end
					end
					if not enabled then
						require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					end
				end,
			},
			{ "nvim-treesitter/playground" },
			{ "nvim-treesitter/nvim-treesitter-refactor" },
		},

		enable = true,
		lazy = false,

		keys = {
			{ "<c-space>", desc = "Increment selection" },
			{ "<bs>", desc = "Decrement selection", mode = "x" },
		},

		opts = {
			highlight = { enable = true },
			indent = { enable = true, disable = { "python" } },
			context_commentstring = { enable = true, enable_autocmd = false },
			playground = {
				enable = true,
				disable = {},
				updatetime = 25,
				persist_queries = false,
			},
			refactor = {
				highlight_definitions = {
					enable = true,
					clear_on_cursor_move = true,
				},
				highlight_current_scope = { enable = true },
				smart_rename = { enable = true },
				navigation = { enable = true },
			},
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"go",
				"gomod",
				"gosum",
				"help",
				"html",
				"javascript",
				"json",
				"lua",
				"luap",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"query",
				"regex",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
		},

		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
