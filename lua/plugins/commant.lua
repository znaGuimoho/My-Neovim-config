return {
	"numToStr/Comment.nvim",
	event = "VeryLazy",
	config = function()
		require("Comment").setup({
			-- Add a space between comment delimiter and code
			padding = true,
			-- Keep cursor position after commenting
			sticky = true,
			-- Lines to be ignored while (un)comment
			ignore = nil,
			-- Normal mode mappings
			toggler = {
				line = "<leader>/", -- toggle line comment
				block = "<leader>?", -- toggle block comment
			},
			-- Visual/operator mode mappings
			opleader = {
				line = "<leader>/", -- visual: toggle line comment
				block = "<leader>?", -- visual: toggle block comment
			},
			extra = {
				above = "<leader>O", -- add comment on line above
				below = "<leader>o", -- add comment on line below
				eol = "<leader>A", -- add comment at end of line
			},
			mappings = {
				basic = true,
				extra = true,
			},
		})
	end,
}
