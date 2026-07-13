--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: terminal.lua
-- Purpose: Configures terminal integration via toggleterm.nvim.
-- Author: Mohammed
--
-- Delegates all keymaps to lua/core/keymaps.lua and keeps the custom floating
-- terminal module (lua/util/terminal.lua) for audio feedback on errors.
--══════════════════════════════════════════════════════════════════════════════
--]]

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰏖 Plugin Setup
-- ─────────────────────────────────────────────────────────────────────────────

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "ToggleTermToggleAll" },

    ---Apply the toggleterm.nvim configuration.
    ---@return nil
    config = function()
      require("toggleterm").setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = nil, -- NOTE: Keybindings live in lua/core/keymaps.lua for consistency.
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = "float",
        close_on_exit = false, -- Keep the terminal open so output can be reviewed.
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = "rounded",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
        winbar = {
          enabled = false,
        },
      })
    end,
  },
}
