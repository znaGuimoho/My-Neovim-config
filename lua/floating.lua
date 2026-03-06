local M = {}

local state = {
	floating = { buf = -1, win = -1 },
}

local function play_audio(filepath)
	local players = { "afplay", "mpv", "ffplay", "aplay", "paplay" }
	for _, player in ipairs(players) do
		if vim.fn.executable(player) == 1 then
			vim.fn.jobstart({ player, filepath }, { detach = true })
			return
		end
	end
	vim.notify("No audio player found!", vim.log.levels.WARN)
end

local function open_floating_window(opts)
	opts = opts or {}
	local ui = vim.api.nvim_list_uis()[1]
	local screen_w = ui.width
	local screen_h = ui.height
	local width = opts.width or math.floor(screen_w * 0.8)
	local height = opts.height or math.floor(screen_h * 0.8)
	local row = math.floor((screen_h - height) / 2)
	local col = math.floor((screen_w - width) / 2)

	local buf
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	return { buf = buf, win = win }
end

-- Called from zshrc via --remote-expr on every failed command
function M.on_error(exit_code)
	vim.schedule(function()
		play_audio("/home/znagui/Music/faaah.mp3")

		if vim.api.nvim_win_is_valid(state.floating.win) then
			vim.api.nvim_win_set_config(state.floating.win, { border = "solid" })

			-- Reset border back to rounded after 2 seconds
			vim.defer_fn(function()
				if vim.api.nvim_win_is_valid(state.floating.win) then
					vim.api.nvim_win_set_config(state.floating.win, { border = "rounded" })
				end
			end, 2000)
		end

		vim.notify("Command failed with exit code: " .. exit_code, vim.log.levels.ERROR)
	end)
end

function M.toggle(opts)
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = open_floating_window({ buf = state.floating.buf })

		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()

			vim.api.nvim_create_autocmd("TermClose", {
				buffer = state.floating.buf,
				once = true,
				callback = function()
					local exit_code = vim.v.event.status
					if exit_code ~= 0 then
						M.on_error(exit_code)
					end
				end,
			})
		end
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

return M
