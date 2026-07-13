--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: linting.lua
-- Purpose: Configures asynchronous linting via nvim-lint.
-- Author: Mohammed
--
-- Linters run after saving or leaving insert mode. They are installed through
-- Mason; see lua/plugins/lsp.lua for the LSP/Mason setup.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰁨 Linter assignments by filetype
      -- ─────────────────────────────────────────────────────────────────────────────

      -- Map each filetype to its linter(s). Keep this in sync with Mason's
      -- installed packages so diagnostics appear reliably across projects.
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        python = { "ruff" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        yaml = { "yamllint" },
        markdown = { "markdownlint" },
        dockerfile = { "hadolint" },
      }

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰨖 Autocommands
      -- ─────────────────────────────────────────────────────────────────────────────

      -- Trigger linting on events that indicate the buffer content has settled.
      -- Skip non-file buffers (e.g., floating windows, terminals) to avoid noise.
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.buftype == "" then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
