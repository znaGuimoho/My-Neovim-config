--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: options.lua
-- Purpose: Configures global Neovim options for an IDE-like editing experience.
-- Author: Mohammed
--
-- This file centralizes editor defaults for:
-- - Line numbers, relative numbers, and sign columns
-- - Clipboard and mouse integration
-- - Search behavior
-- - Indentation (4 spaces by default)
-- - Window splitting, scrolling, and UI polish
-- - Backup, swap, and undo persistence
--══════════════════════════════════════════════════════════════════════════════
--]]

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Leader Keys
-- ─────────────────────────────────────────────────────────────────────────────

-- NOTE: Leader keys must be defined before lazy.nvim loads plugins so keymaps
--       are created with the correct prefix.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ─────────────────────────────────────────────────────────────────────────────
-- 🎨 UI / Appearance
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 4       -- Reserve fixed gutter width to prevent layout jumps
vim.o.signcolumn = "yes"    -- Always show gutter so diagnostics/git signs don't shift text
vim.o.cursorline = true     -- Highlight the current line for easier orientation
vim.o.colorcolumn = "120"   -- Visual guide to keep lines readable/reviewable
vim.o.showmode = false      -- Mode is already shown by the statusline plugin
vim.o.cmdheight = 1
vim.o.pumheight = 10        -- Limit completion popup height
vim.o.termguicolors = true  -- Enable 24-bit color support
vim.o.showtabline = 1       -- Show tabline only when multiple tabs exist
vim.o.laststatus = 3        -- Single global statusline across all windows
vim.o.title = true
vim.o.titlestring = "%f - nvim" -- Reflect the current file in the window title

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰌵 Input Integration
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.mouse = "a"           -- Enable mouse support in all modes
vim.o.clipboard = "unnamedplus" -- Use the system clipboard by default

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Search
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.hlsearch = false      -- Don't keep the previous search highlighted
vim.o.ignorecase = true     -- Case-insensitive search by default
vim.o.smartcase = true      -- ...unless the query contains uppercase letters
vim.o.incsearch = true      -- Live preview of search matches while typing

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰒓 Indentation
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4        -- 4 spaces: consistent indentation across the project
vim.o.expandtab = true      -- Insert spaces instead of literal tab characters
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.breakindent = true    -- Preserve indentation when wrapping long lines
vim.o.linebreak = true      -- Wrap at word boundaries rather than mid-word
vim.o.wrap = false          -- Don't wrap lines by default

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Window Behavior
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.splitbelow = true     -- Open horizontal splits below the current window
vim.o.splitright = true     -- Open vertical splits to the right

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Scrolling
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.scrolloff = 8         -- Keep cursor 8 lines away from the top/bottom edges
vim.o.sidescrolloff = 8     -- Same padding for horizontal scrolling
vim.o.smoothscroll = true   -- Smooth scrolling when cursor moves off-screen (Neovim 0.10+)

-- ─────────────────────────────────────────────────────────────────────────────
-- ⚡ Performance
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.updatetime = 250      -- Faster CursorHold events for diagnostics/completion
vim.o.timeoutlen = 300      -- Short delay for resolving ambiguous keymaps

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Persistence
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false   -- Disable swap/backup files to reduce noise
vim.o.undofile = true       -- Keep undo history across sessions

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰅴 Completion
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.completeopt = "menuone,noselect" -- Show completion menu without auto-selecting

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 Editing Behavior
-- ─────────────────────────────────────────────────────────────────────────────

vim.o.backspace = "indent,eol,start"   -- Allow backspace over indentation, EOL, and insert start
vim.o.whichwrap = "bs<>[]hl"           -- Let cursor wrap across lines with arrow keys
vim.o.iskeyword = vim.o.iskeyword .. ",-" -- Treat hyphenated words as single words (e.g. css-class)

-- Don't auto-insert comment leaders when pressing <CR> or `o` in comment blocks
vim.opt.formatoptions:remove({ "c", "r", "o" })

vim.opt.shortmess:append("c")          -- Suppress verbose completion messages

-- Avoid conflicts when both Vim and Neovim are installed system-wide
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")

vim.o.conceallevel = 0                 -- Keep markdown code fences and other concealed text visible

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰔱 Folding
-- ─────────────────────────────────────────────────────────────────────────────

-- Defaults tuned for nvim-ufo: folds are enabled but start fully open.
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
