return {
	"folke/which-key.nvim",
	lazy = false,
	config = function()
		local floating = require("floating")

		vim.api.nvim_create_user_command("FolwtingCommand", function()
			floating.toggle()
		end, {})

		-- Optional: bind to a key
		vim.keymap.set("n", "<leader>ft", "<cmd>FolwtingCommand<CR>", {
			desc = "Toggle floating terminal",
		})
	end,
}
