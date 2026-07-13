--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: theme.lua
-- Purpose: Configures the Catppuccin colorscheme and its plugin integrations.
-- Author: Mohammed
--
-- Catppuccin is chosen for its broad ecosystem support, four variants
-- (latte, frappe, macchiato, mocha), and polished modern look. It integrates
-- with Telescope, Lualine, Gitsigns, Notify, Treesitter, and many other plugins
-- out of the box, giving a consistent IDE-like appearance.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,

    -- ─────────────────────────────────────────────────────────────────────────────
    -- 󰏖 Plugin Setup
    -- ─────────────────────────────────────────────────────────────────────────────

    --- Configure Catppuccin and apply it as the active colorscheme.
    config = function()
      require("catppuccin").setup({
        -- Adapt to the current `vim.o.background` value.
        flavour = "auto",
        background = {
          light = "latte",
          dark = "mocha",
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 🎨 Appearance
        -- ─────────────────────────────────────────────────────────────────────────────

        -- Keep opaque buffers; set to true only if your terminal background
        -- should show through Neovim's windows.
        transparent_background = false,
        show_end_of_buffer = false,
        term_colors = true,
        dim_inactive = {
          enabled = false,
          shade = "dark",
          percentage = 0.15,
        },
        no_italic = false,
        no_bold = false,
        no_underline = false,

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰘧 Syntax Styles
        -- ─────────────────────────────────────────────────────────────────────────────

        styles = {
          comments = { "italic" },
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
        },

        color_overrides = {},
        custom_highlights = {},

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰏖 Plugin Integrations
        -- ─────────────────────────────────────────────────────────────────────────────

        -- Enable the built-in integrations by default; individual plugins can
        -- still be toggled below.
        default_integrations = true,
        integrations = {
          blink_cmp = true,
          cmp = true,
          dap = true,
          dap_ui = true,
          dashboard = true,
          dropbar = {
            enabled = true,
            color_mode = true,
          },
          fidget = true,
          flash = true,
          gitsigns = true,
          indent_blankline = {
            enabled = true,
            scope_color = "lavender",
            colored_indent_levels = false,
          },
          lsp_trouble = true,
          mason = true,
          markdown = true,
          mini = {
            enabled = true,
            indentscope_color = "lavender",
          },
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          neotree = true,
          notify = true,
          -- Prefer Neo-tree for the file explorer.
          nvimtree = false,
          rainbow_delimiters = true,
          telescope = {
            enabled = true,
            style = "nvchad",
          },
          treesitter = true,
          treesitter_context = true,
          ufo = true,
          which_key = true,
        },
      })

      -- Apply the colorscheme after all options and integrations are set.
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
