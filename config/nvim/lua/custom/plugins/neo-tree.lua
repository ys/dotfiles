vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require('neo-tree').setup {
			keys = {
				{
					"<leader>fe",
					function()
						require("neo-tree.command").execute({
							toggle = true,
							source = "buffers",
							position = "left",
						})
					end,
					desc = "Buffers (root dir)",
				},
			},
		}
	end,
	lazy = false
}
