--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: init.lua
-- Purpose: Neovim configuration entry point.
-- Author: Mohammed
--
-- Loads core settings first, then bootstraps lazy.nvim and loads all plugin
-- specs. Core modules are loaded before plugins so that options, leader keys,
-- and autocommands are available during plugin initialization.
--══════════════════════════════════════════════════════════════════════════════
--]]

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Core Setup
-- ─────────────────────────────────────────────────────────────────────────────

-- Load core modules before plugins so global state is ready for plugin specs.
require("core.options")  -- Base options must exist before plugins read them
require("core.keymaps")  -- Leader/global mappings must be defined early
require("core.autocmds") -- Diagnostics and autocommands available during init
require("core.lazy")     -- Bootstrap plugin manager after core state is ready

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰏖 Custom Commands
-- ─────────────────────────────────────────────────────────────────────────────

--- Toggle the custom floating terminal on demand.
-- Lazily loads `util.terminal` only when the command is actually invoked.
vim.api.nvim_create_user_command("FolwtingCommand", function()
  require("util.terminal").toggle()
end, {})

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰈔 Session Management
-- ─────────────────────────────────────────────────────────────────────────────

-- Restore a local session file if one exists in the current working directory.
-- This preserves the existing session workflow from the previous config.
local session_file = ".session.vim"
local f = io.open(session_file, "r")
if f then
  f:close()
  vim.cmd("source " .. session_file)
end
