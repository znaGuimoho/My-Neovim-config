--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: lazy.lua
-- Purpose: Bootstraps lazy.nvim and loads all plugin specs from lua/plugins.
-- Author: Mohammed
--
-- Responsibilities:
-- - Ensure lazy.nvim is installed in stdpath("data").
-- - Add lazy.nvim to the runtime path.
-- - Import plugin specs organized by category.
--══════════════════════════════════════════════════════════════════════════════
--]]

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰏖 Bootstrap lazy.nvim
-- ─────────────────────────────────────────────────────────────────────────────

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- NOTE: Auto-install lazy.nvim if it is not already present.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none", -- Shallow clone for a faster initial install.
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Pin to stable releases instead of the default branch.
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰏖 Plugin Specs
-- ─────────────────────────────────────────────────────────────────────────────

--- Load all plugin specs through lazy.nvim.
-- Specs are grouped by category so each file has a single responsibility.
require("lazy").setup({
  { import = "plugins.theme" },
  { import = "plugins.ui" },
  { import = "plugins.editor" },
  { import = "plugins.treesitter" },
  { import = "plugins.telescope" },
  { import = "plugins.files" },
  { import = "plugins.lsp" },
  { import = "plugins.completion" },
  { import = "plugins.formatting" },
  { import = "plugins.linting" },
  { import = "plugins.git" },
  { import = "plugins.terminal" },
  { import = "plugins.debug" },
  { import = "plugins.qol" },
  { import = "plugins.docs" },
}, {

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰒓 Lazy Options
-- ─────────────────────────────────────────────────────────────────────────────

  defaults = {
    lazy = true, -- Lazy-load by default to keep startup fast.
  },
  install = {
    colorscheme = { "catppuccin", "habamax" }, -- Fallback colors during first install.
  },
  checker = {
    enabled = true, -- Periodically check for available plugin updates.
    notify = false, -- Avoid spamming update notifications on startup.
  },
  change_detection = {
    notify = false, -- Stay quiet when plugin specs are edited.
  },
  performance = {
    rtp = {
      disabled_plugins = {
        -- PERF: Disable rarely-used built-in plugins to reduce startup overhead.
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    -- Use Nerd Font icons when available; otherwise fall back to unicode glyphs.
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
})
