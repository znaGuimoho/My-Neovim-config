--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: docs.lua
-- Purpose: Documentation rendering and comment enhancements.
-- Author: Mohammed
--
-- Plugins:
--   - markview.nvim : Renders Markdown, Typst, LaTeX and HTML inline inside
--     buffers, including code comments.
--   - mini.hipatterns : Highlights inline color tags and priority labels in
--     comments and documentation.
--
-- NOTE: Colored comment keywords (TODO, FIX, NOTE, etc.) are configured in
-- qol.lua via todo-comments.nvim.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  -- Markdown / markup preview inside buffers and comments.
  -- NOTE: markview is internally lazy; avoid lazy-loading it further so buffer
  --       attachment happens immediately on open.
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("markview").setup({
        -- Render in normal mode and command-line window.
        modes = { "n", "no", "c" },
        -- Keep the source visible while rendering on top in normal mode.
        hybrid_modes = { "n" },
        -- Ensure conceal settings let the renderer show styled text.
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "c"
          end,
        },
      })
    end,
  },

  -- Inline color tags and priority labels (e.g. [RED], HIGH PRIORITY).
  {
    "echasnovski/mini.hipatterns",
    event = "VeryLazy",
    config = function()
      local hipatterns = require("mini.hipatterns")

      hipatterns.setup({
        highlighters = {
          -- Color tags.
          red = { pattern = "%[RED%]", group = "MiniHipatternsRed" },
          green = { pattern = "%[GREEN%]", group = "MiniHipatternsGreen" },
          blue = { pattern = "%[BLUE%]", group = "MiniHipatternsBlue" },
          yellow = { pattern = "%[YELLOW%]", group = "MiniHipatternsYellow" },
          purple = { pattern = "%[PURPLE%]", group = "MiniHipatternsPurple" },
          orange = { pattern = "%[ORANGE%]", group = "MiniHipatternsOrange" },

          -- Priority / status labels.
          high_priority = { pattern = "%f[%w]HIGH PRIORITY%f[%W]", group = "MiniHipatternsRed" },
          low_priority = { pattern = "%f[%w]LOW PRIORITY%f[%W]", group = "MiniHipatternsGreen" },
          optional = { pattern = "%f[%w]OPTIONAL%f[%W]", group = "MiniHipatternsBlue" },
          experimental = { pattern = "%f[%w]EXPERIMENTAL%f[%W]", group = "MiniHipatternsYellow" },
        },
      })

      -- Define highlight groups for each color tag.
      vim.api.nvim_set_hl(0, "MiniHipatternsRed", { fg = "#ff5555", bold = true })
      vim.api.nvim_set_hl(0, "MiniHipatternsGreen", { fg = "#50fa7b", bold = true })
      vim.api.nvim_set_hl(0, "MiniHipatternsBlue", { fg = "#8be9fd", bold = true })
      vim.api.nvim_set_hl(0, "MiniHipatternsYellow", { fg = "#f1fa8c", bold = true })
      vim.api.nvim_set_hl(0, "MiniHipatternsPurple", { fg = "#bd93f9", bold = true })
      vim.api.nvim_set_hl(0, "MiniHipatternsOrange", { fg = "#ffb86c", bold = true })
    end,
  },
}
