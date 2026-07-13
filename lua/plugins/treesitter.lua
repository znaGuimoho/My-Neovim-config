--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: treesitter.lua
-- Purpose: Configures Tree-sitter parsers, highlighting, text objects, and rainbow delimiters.
-- Author: Mohammed
--
-- NOTE: Treesitter-textobjects keymaps are defined here because the plugin reads
--       them from the setup table. Most other keymaps live in lua/core/keymaps.lua.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "HiPhish/rainbow-delimiters.nvim",
    },

    --- Configures Tree-sitter parsers, highlighting, text objects, and rainbow delimiters.
    config = function()
      require("nvim-treesitter.configs").setup({

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰏗 Parser Installation
        -- ─────────────────────────────────────────────────────────────────────────────
        ensure_installed = {
          "bash",
          "c",
          "cpp",
          "css",
          "go",
          "html",
          "java",
          "javascript",
          "json",
          "jsonc",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "query",
          "regex",
          "rust",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        sync_install = false,
        auto_install = true,

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰭟 Highlight & Indent
        -- ─────────────────────────────────────────────────────────────────────────────
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
          disable = { "yaml" }, -- YAML indentation is often better handled by Vim
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰘧 Incremental Selection
        -- ─────────────────────────────────────────────────────────────────────────────
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<S-CR>",
            node_decremental = "<BS>",
          },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰌵 Text Objects
        -- ─────────────────────────────────────────────────────────────────────────────
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = false, -- Disabled to avoid keymap conflicts; enable in keymaps.lua if desired
          },
        },
      })

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰔉 Rainbow Delimiters
      -- ─────────────────────────────────────────────────────────────────────────────
      local rainbow_delimiters = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          lua = "rainbow-blocks",
        },
        priority = {
          [""] = 110,
          lua = 210,
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰑌 Playground
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "nvim-treesitter/playground",
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  },
}
