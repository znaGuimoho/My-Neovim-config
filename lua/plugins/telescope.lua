--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: telescope.lua
-- Purpose: Configures Telescope fuzzy finder with VS Code Quick Open ergonomics.
-- Author: Mohammed
--
-- Provides:
-- - Fast file, text, git, and diagnostic pickers
-- - Native fzf sorter when available
-- - Consistent vim.ui.select replacement via ui-select
--
-- All keymaps are defined in lua/core/keymaps.lua.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        --- Only enable fzf-native when `make` is available on the system.
        -- This avoids build failures on machines without a C compiler toolchain.
        -- @return boolean true if `make` is executable.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-tree/nvim-web-devicons",
      "ahmedkhalf/project.nvim",
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- 󰈔 Telescope Setup
    -- ─────────────────────────────────────────────────────────────────────────────

    --- Bootstrap Telescope defaults, pickers, and extensions.
    config = function()
      local actions = require("telescope.actions")

      require("telescope").setup({
        defaults = {

          -- ─────────────────────────────────────────────────────────────────────────────
          -- 󰒓 Options / Settings
          -- ─────────────────────────────────────────────────────────────────────────────

          prompt_prefix = " ",
          selection_caret = " ",
          -- Keep the matched filename visible even when paths are long.
          path_display = { "filename_first" },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "bottom",
              preview_width = 0.55,
              width = 0.95,
              height = 0.90,
            },
            vertical = {
              mirror = false,
              width = 0.95,
              height = 0.90,
            },
          },

          -- ─────────────────────────────────────────────────────────────────────────────
          -- 󰌵 Keymaps
          -- ─────────────────────────────────────────────────────────────────────────────

          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-l>"] = actions.select_default,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-a>"] = actions.toggle_all,
            },
            n = {
              ["q"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-l>"] = actions.select_default,
            },
          },

          -- Skip generated/dependency directories so pickers stay fast and relevant.
          file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "%.venv/",
            "__pycache__/",
            "%.mypy_cache/",
            "%.pytest_cache/",
            "%.ruff_cache/",
            "target/",
            "build/",
            "dist/",
          },

          -- rg flags tuned for editor integration: no color, smart case, location metadata.
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
          },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰈔 Picker Configurations
        -- ─────────────────────────────────────────────────────────────────────────────

        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            --- Append extra rg flags for live grep.
            -- @return table List of additional ripgrep arguments.
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            initial_mode = "normal",
            sort_lastused = true,
            mappings = {
              n = {
                ["d"] = actions.delete_buffer,
                ["l"] = actions.select_default,
              },
            },
          },
          oldfiles = {
            initial_mode = "normal",
          },
          marks = {
            initial_mode = "normal",
          },
          git_files = {
            previewer = false,
          },
        },

        -- ─────────────────────────────────────────────────────────────────────────────
        -- 󰏖 Extensions
        -- ─────────────────────────────────────────────────────────────────────────────

        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Load optional extensions safely so missing compiled binaries do not break startup.
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")
      pcall(require("telescope").load_extension, "projects")
    end,
  },
}
