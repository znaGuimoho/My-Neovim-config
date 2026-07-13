--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: formatting.lua
-- Purpose: Configures conform.nvim for automatic and manual code formatting.
-- Author: Mohammed
--
-- Formats on save using a per-filetype formatter list and falls back to LSP
-- formatting when no dedicated formatter is available. The manual format
-- keymap lives in lua/core/keymaps.lua under LSP mappings.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- 󰏖 Plugin Setup
    -- ─────────────────────────────────────────────────────────────────────────────

    --- Configure conform formatters, filetype mappings, and format-on-save rules.
    config = function()
      require("conform").setup({
        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰒡 Formatters by Filetype
        -- ─────────────────────────────────────────────────────────────────────────────

        formatters_by_ft = {
          -- Python: sort imports before formatting with black.
          python = { "isort", "black" },

          -- Web, markup, and data formats handled by prettier.
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          json = { "prettier" },
          jsonc = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },

          -- Systems and lower-level languages.
          lua = { "stylua" },
          sh = { "shfmt" },
          bash = { "shfmt" },
          zsh = { "shfmt" },
          terraform = { "terraform_fmt" },
          rust = { "rustfmt" },
          go = { "gofmt" },
          c = { "clang_format" },
          cpp = { "clang_format" },

          -- Java: rely on jdtls via LSP fallback instead of a standalone formatter.
          java = {},

          -- Fallback for all other filetypes: trim trailing whitespace and empty lines.
          ["_"] = { "trim_whitespace", "trim_newlines" },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰨖 Format on Save
        -- ─────────────────────────────────────────────────────────────────────────────

        -- Skip heavy or problematic buffers before requesting a format.
        format_on_save = function(bufnr)
          local ignore_filetypes = { "sql" }
          if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
          end

          -- PERF: avoid formatting files larger than 1 MiB to keep saves responsive.
          local max_filesize = 1024 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
          if ok and stats and stats.size > max_filesize then
            return
          end

          return {
            timeout_ms = 3000,
            lsp_fallback = true,
          }
        end,

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰒓 Formatter Options
        -- ─────────────────────────────────────────────────────────────────────────────

        -- NOTE: keep these args aligned with the project's style preferences elsewhere.
        formatters = {
          black = { prepend_args = { "--line-length", "88" } },
          isort = { prepend_args = { "--profile", "black" } },
          prettier = {
            prepend_args = { "--tab-width", "2", "--single-quote", "false", "--trailing-comma", "es5" },
          },
          stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
          shfmt = { prepend_args = { "-i", "4" } },
        },
      })
    end,
  },
}
