--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: completion.lua
-- Purpose: Configure the completion engine (blink.cmp) and snippet support (LuaSnip).
-- Author: Mohammed
--
-- Features:
-- - LSP, snippet, path, buffer, and ripgrep completion sources
-- - Completion-driven keymaps passed directly to blink.cmp
-- - Command-line completion for search and ex commands
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    version = "*", -- Stay on the latest stable release tag.
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "mikavilpas/blink-ripgrep.nvim",
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- 󰏖 Plugin Setup
    -- ─────────────────────────────────────────────────────────────────────────────

    --- Initialize blink.cmp and load VS Code-style snippets into LuaSnip.
    config = function()
      local luasnip = require("luasnip")
      luasnip.config.setup({})
      require("luasnip.loaders.from_vscode").lazy_load()

      require("blink.cmp").setup({

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰌵 Keymaps
        -- ─────────────────────────────────────────────────────────────────────────────

        -- NOTE: These are completion-menu keymaps, passed to blink.cmp rather than
        -- vim.keymap.set, so they only take effect while the menu is active.
        keymap = {
          preset = "default",
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<C-j>"] = { "select_next", "fallback" },
          ["<CR>"] = { "accept", "fallback" },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<C-l>"] = { "snippet_forward", "fallback" },
          ["<C-h>"] = { "snippet_backward", "fallback" },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 🎨 Appearance
        -- ─────────────────────────────────────────────────────────────────────────────

        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "mono",
          kind_icons = {
            Text = "󰉿",
            Method = "󰊕",
            Function = "󰊕",
            Constructor = "",
            Field = "",
            Variable = "󰆧",
            Class = "󰌗",
            Interface = "",
            Module = "",
            Property = "",
            Unit = "",
            Value = "󰎠",
            Enum = "",
            Keyword = "󰌋",
            Snippet = "",
            Color = "󰏘",
            File = "󰈙",
            Reference = "",
            Folder = "󰉋",
            EnumMember = "",
            Constant = "󰇽",
            Struct = "",
            Event = "",
            Operator = "󰆕",
            TypeParameter = "󰊄",
          },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰅴 Snippets
        -- ─────────────────────────────────────────────────────────────────────────────

        snippets = {
          preset = "luasnip",

          --- Expand the given snippet body through LuaSnip.
          --- @param snippet string The snippet body to expand at the cursor.
          expand = function(snippet)
            luasnip.lsp_expand(snippet)
          end,

          --- Check whether the cursor is currently inside an active snippet.
          --- @param filter table|nil Optional filter passed by blink.cmp.
          --- @return boolean
          active = function(filter)
            return luasnip.in_snippet()
          end,

          --- Move to the next or previous snippet tab stop.
          --- @param direction number 1 for forward, -1 for backward.
          jump = function(direction)
            luasnip.jump(direction)
          end,
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰅴 Completion Sources
        -- ─────────────────────────────────────────────────────────────────────────────

        -- NOTE: score_offset is the primary ranking mechanism. Larger values win, so
        -- semantic sources (LSP, path) rank above snippets, buffer words, and ripgrep.
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
          providers = {
            lsp = { score_offset = 4 },
            path = { score_offset = 3 },
            snippets = { score_offset = 2 },
            buffer = { score_offset = 1 },

            -- Ripgrep searches the project for additional text matches.
            ripgrep = {
              module = "blink-ripgrep",
              name = "Ripgrep",
              score_offset = 0,
              opts = {
                prefix_min_len = 3,
                context_size = 5,
                max_filesize = "1M",
                project_root_marker = ".git",
                project_root_fallback = true,
              },
            },
          },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰅴 Completion Menu
        -- ─────────────────────────────────────────────────────────────────────────────

        completion = {
          menu = {
            border = "rounded",
            draw = {
              columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = { border = "rounded" },
          },
          ghost_text = { enabled = true },
          accept = {
            auto_brackets = {
              -- Reduce manual typing for function-like completions.
              enabled = true,
            },
          },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰋼 Signature Help
        -- ─────────────────────────────────────────────────────────────────────────────

        signature = {
          enabled = true,
          window = { border = "rounded" },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        --  Command Line
        -- ─────────────────────────────────────────────────────────────────────────────

        cmdline = {
          enabled = true,

          --- Pick completion sources based on the active command-line mode.
          --- @return string[] Source names to enable for the current cmdline.
          sources = function()
            local type = vim.fn.getcmdtype()

            -- Search commands (/ or ?) should complete from buffer contents.
            if type == "/" or type == "?" then
              return { "buffer" }
            end

            -- Ex commands (:) should complete built-in commands.
            if type == ":" then
              return { "cmdline" }
            end

            return {}
          end,
          keymap = {
            preset = "default",
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
          },
        },
      })
    end,
  },
}
