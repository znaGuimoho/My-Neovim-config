return {
	"andweeb/presence.nvim", -- NOTE: check https://github.com/andweeb/presence.nvim for more details
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = function()
		require("presence").setup({
			auto_update = true,
			neovim_image_text = "The One True Text Editor",
			main_image = "nvim",
			client_id = "1468323244091379903",
			log_level = nil,
			debounce_timeout = 10,
			enable_line_number = false,
			blacklist = {},
			buttons = true,
			file_assets = {},
			show_time = true,

			-- Rich Presence text options
			editing_text = "Editing %s",

			git_commit_text = "Committing changes",
			plugin_manager_text = "Managing plugins",
			reading_text = "Reading %s",

			file_explorer_text = "Browsing ",
			-- file_explorer_text  = "Browsing %s",

			workspace_text = "Working on something",
			-- workspace_text      = "Working on %s",

			line_number_text = "",
			-- line_number_text    = "Line %s out of %s",
		})
	end,
}
