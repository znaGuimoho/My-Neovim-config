--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: terminal.lua
-- Purpose: Custom floating terminal with audio feedback on command failure.
-- Author: Mohammed
--
-- Preserved from the previous configuration:
-- - When a command exits with a non-zero status, an audio clip is played and
--   the floating window border briefly changes to solid before returning to rounded.
-- - Used by lua/plugins/terminal.lua (lazy loading) and lua/core/keymaps.lua
--   (the <leader>tf mapping).
--
-- NEW: Per-command error feedback (not just shell-exit feedback).
-- - Neovim's TermClose event only fires when the *shell process* exits, not
--   when an individual command inside it fails. To catch per-command
--   failures, zsh reports back via `nvim --remote-expr` on every failed
--   command using a precmd hook (see accompanying .zshrc snippet).
-- - This calls _G.NvimTermOnError, a thin wrapper around M.on_error that is
--   safe to invoke from --remote-expr (returns a string, doesn't error if
--   the module path changes).
--══════════════════════════════════════════════════════════════════════════════
--]]

local M = {}

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰄛 State
-- ─────────────────────────────────────────────────────────────────────────────

local state = {
  floating = { buf = -1, win = -1 },
  term_exited = false,
  last_exit_code = 0,
}

-- ─────────────────────────────────────────────────────────────────────────────
--  Terminal Helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Play an audio file using the first available system player.
---
--- NOTE: Falls back silently to a notification if no supported player is found.
--- Supported players, in order of preference:
--- - afplay (macOS)
--- - mpv
--- - ffplay
--- - aplay
--- - paplay
---
--- @param filepath string Absolute path to the audio file.
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

--- Open a centered floating window, reusing the existing buffer if it is still valid.
---
--- @param opts? table Optional settings.
--- @param opts.width? number Window width in columns.
--- @param opts.height? number Window height in rows.
--- @param opts.buf? number Buffer handle to reuse, if valid.
--- @return table { buf = number, win = number }
local function open_floating_window(opts)
  opts = opts or {}
  local ui = vim.api.nvim_list_uis()[1]
  local screen_w = ui.width
  local screen_h = ui.height
  local width = opts.width or math.floor(screen_w * 0.8)
  local height = opts.height or math.floor(screen_h * 0.8)
  local row = math.floor((screen_h - height) / 2)
  local col = math.floor((screen_w - width) / 2)

  local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)

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

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰅖 Error Feedback
-- ─────────────────────────────────────────────────────────────────────────────

--- Handle a failed command (or failed shell exit).
---
--- Plays the failure audio clip and flashes the window border to draw attention
--- without stealing focus from the editor. Safe to call both from the internal
--- TermClose autocmd and externally via --remote-expr, since it never touches
--- state.term_exited / state.last_exit_code (that bookkeeping is only for the
--- "should we discard the buffer on next toggle" decision, handled separately).
---
--- @param exit_code number|string The shell exit status.
--- @return string "" (so this is safe to use as a --remote-expr return value)
function M.on_error(exit_code)
  exit_code = tonumber(exit_code) or -1

  vim.schedule(function()
    play_audio("/home/znagui/Music/faaah.mp3")

    if vim.api.nvim_win_is_valid(state.floating.win) then
      vim.api.nvim_win_set_config(state.floating.win, { border = "solid" })
      vim.defer_fn(function()
        if vim.api.nvim_win_is_valid(state.floating.win) then
          vim.api.nvim_win_set_config(state.floating.win, { border = "rounded" })
        end
      end, 2000)
    end

    vim.notify("Command failed with exit code: " .. exit_code, vim.log.levels.ERROR)
  end)

  return ""
end

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰖴 Remote entry point (called by zsh's precmd hook via --remote-expr)
-- ─────────────────────────────────────────────────────────────────────────────

--- Global wrapper so `nvim --remote-expr "v:lua.NvimTermOnError(<code>)"` works
--- regardless of how this module is required internally. Deliberately does NOT
--- touch state.term_exited / state.last_exit_code, so it never triggers the
--- "discard buffer" branch in M.toggle() below — per-command failures leave
--- the terminal exactly as it was.
---
--- @param exit_code number|string
--- @return string ""
_G.NvimTermOnError = function(exit_code)
  return M.on_error(exit_code)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰖵 Toggle Logic
-- ─────────────────────────────────────────────────────────────────────────────

--- Toggle the custom floating terminal.
---
--- Opens the terminal if it is not currently visible; otherwise hides it.
--- A successful *shell* exit (e.g. typing `exit`) discards the old buffer so
--- the next toggle starts fresh, while a failed shell exit keeps the buffer
--- visible for post-mortem inspection. Individual failed *commands* inside a
--- still-running shell never reach this branch at all.
---
--- @param opts? table Currently unused; reserved for future window options.
function M.toggle(opts)
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    -- Discard stale buffers after clean shell exits; keep failed shell exits for review.
    if state.term_exited and state.last_exit_code == 0 and vim.api.nvim_buf_is_valid(state.floating.buf) then
      vim.api.nvim_buf_delete(state.floating.buf, { force = true })
      state.floating.buf = -1
      state.term_exited = false
      state.last_exit_code = 0
    end

    state.floating = open_floating_window({ buf = state.floating.buf })

    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
      vim.bo[state.floating.buf].bufhidden = "hide"

      vim.api.nvim_create_autocmd("TermClose", {
        buffer = state.floating.buf,
        once = true,
        callback = function()
          local exit_code = vim.v.event.status
          state.term_exited = true
          state.last_exit_code = exit_code
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
