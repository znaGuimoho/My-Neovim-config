--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: git.lua
-- Purpose: Configures git-related plugins for inline status, diff views, and LazyGit integration.
-- Author: Mohammed
--
-- - gitsigns: inline hunks and blame information
-- - diffview: diff and file history panels
-- - lazygit: floating terminal UI for Git
--
-- NOTE: Most keymaps are defined in lua/core/keymaps.lua.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {

  -- ─────────────────────────────────────────────────────────────────────────────
  --  Gitsigns (Inline Hunks & Blame)
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Provide inline git feedback and hunk actions without leaving the buffer.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },

    --- Configure gitsigns with visual symbols, blame, and buffer attachment.
    config = function()
      require("gitsigns").setup({
        -- Use thin vertical bars for added/changed lines and arrows for deletions.
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "▎" },
        },

        -- Keep staged hunks visually distinct from unstaged ones.
        signs_staged = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
        },

        -- Inline blame is disabled by default; toggle it on demand via keymaps.
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol",
          delay = 500,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

        -- Rounded popup anchored to the cursor for hunk previews.
        preview_config = {
          border = "rounded",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },

        --- Per-buffer setup for gitsigns.
        -- Ensures the buffer stays listed in normal buffer workflows.
        -- Keymaps are managed centrally in lua/core/keymaps.lua.
        on_attach = function(bufnr)
          vim.bo[bufnr].buflisted = true
        end,
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  --  Diffview (Diffs & File History)
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Full-featured diff and file history panels for reviewing changes.
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    dependencies = { "nvim-tree/nvim-web-devicons" },

    --- Set up diff views, file history, and merge tool layouts.
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          default = { winbar_info = false },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
          file_history = { winbar_info = false },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = { flatten_dirs = true, folder_statuses = "only_folded" },
          win_config = { position = "left", width = 35 },
        },
        file_history_panel = {
          win_config = { position = "bottom", height = 16 },
        },
        commit_log_panel = { win_config = {} },
        default_args = { DiffviewOpen = {}, DiffviewFileHistory = {} },
        hooks = {},

        -- Add quick close bindings to all diffview views.
        keymaps = {
          view = { q = "<cmd>DiffviewClose<CR>" },
          file_panel = { q = "<cmd>DiffviewClose<CR>" },
          file_history_panel = { q = "<cmd>DiffviewClose<CR>" },
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  --  LazyGit (Floating Terminal)
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Embed the full LazyGit TUI in a floating terminal window.
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = { "nvim-lua/plenary.nvim" },

    --- Tune the floating window geometry and integration behavior.
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border_chars = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_floating_window_use_plenary = 0
      vim.g.lazygit_use_neovim_remote = 1
      vim.g.lazygit_use_custom_config_file_path = 0
    end,
  },
}
