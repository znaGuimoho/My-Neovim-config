--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: autocmds.lua
-- Purpose: Defines general autocommands and buffer appearance tweaks.
-- Author: Mohammed
--
-- This file holds non-keymap autocommands such as yank highlighting,
-- diagnostic styling, terminal padding integration, and documentation
-- tag highlights.
--══════════════════════════════════════════════════════════════════════════════
--]]

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Helpers
-- ─────────────────────────────────────────────────────────────────────────────

--- Create a dedicated autocommand group, clearing any existing commands.
---@param name string The augroup name.
---@return integer augroup_id The created augroup id.
local augroup = function(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰨖 Yank Highlight
-- ─────────────────────────────────────────────────────────────────────────────

-- Briefly highlight the yanked region to give visual feedback on copy operations.
local yank_group = augroup("YankHighlight")
vim.api.nvim_create_autocmd("TextYankPost", {
  group = yank_group,
  pattern = "*",
  callback = function()
    vim.hl.on_yank()
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰁨 Diagnostics
-- ─────────────────────────────────────────────────────────────────────────────

-- Lower semantic token priority so Treesitter highlights win over LSP semantic tokens.
vim.hl.priorities.semantic_tokens = 95

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
    --- Include the diagnostic code (if any) before its message for faster triage.
    ---@param diagnostic vim.Diagnostic The diagnostic to format.
    ---@return string The formatted virtual text.
    format = function(diagnostic)
      local code = diagnostic.code and string.format("[%s] ", diagnostic.code) or ""
      return code .. diagnostic.message
    end,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- Keep diagnostic virtual text transparent by linking it to the base highlight groups.
vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("DiagnosticTransparentBg"),
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
    vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
--  Terminal Padding
-- ─────────────────────────────────────────────────────────────────────────────

-- Remove Kitty window padding while Neovim is open so the UI fills the frame.
local kitty_group = augroup("KittyPadding")
vim.api.nvim_create_autocmd("VimEnter", {
  group = kitty_group,
  pattern = "*",
  callback = function()
    if vim.env.TERM == "xterm-kitty" then
      vim.cmd([[silent !kitty @ set-spacing padding=0 margin=0 3 0 3]])
    end
  end,
})

-- Restore default Kitty padding when leaving Neovim.
vim.api.nvim_create_autocmd("VimLeave", {
  group = kitty_group,
  pattern = "*",
  callback = function()
    if vim.env.TERM == "xterm-kitty" then
      vim.cmd([[silent !kitty @ set-spacing padding=default margin=default]])
    end
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Window Resize
-- ─────────────────────────────────────────────────────────────────────────────

-- Equalize split sizes automatically after the terminal window is resized.
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup("ResizeSplits"),
  pattern = "*",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰉋 Special Filetypes
-- ─────────────────────────────────────────────────────────────────────────────

-- Hide transient helper windows from the buffer list so they don't clutter :ls.
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("CloseWithQ"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- NOTE: Inline color tags ([RED], [GREEN], etc.) and priority labels
--       (HIGH PRIORITY, OPTIONAL, EXPERIMENTAL) are highlighted by
--       mini.hipatterns in lua/plugins/docs.lua.
