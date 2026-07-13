--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: qol.lua
-- Purpose: Configures quality-of-life plugins that smooth daily editing workflows.
-- Author: Mohammed
--
-- Plugins covered:
--   - Automatic session restoration
--   - Visual undo tree
--   - Cursor word highlighting
--   - Modern folds with preview
--   - Project root detection
--   - Diagnostics panel
--   - TODO/FIXME comment highlighting
--   - Discoverable keymap hints
--
-- Keymaps for these plugins are defined in lua/core/keymaps.lua.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰆓 Session Management
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Restore the last editing session automatically per directory.
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
        options = { "buffers", "curdir", "tabpages", "winsize" },
        pre_save = nil,
        save_empty = false,
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰕌 Undo Visualization
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Visual undo tree for inspecting and navigating edit history.
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰸱 Cursor Word Highlight
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Highlight other occurrences of the word under the cursor.
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "dirvish",
          "fugitive",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = nil,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
        should_enable = function(_)
          return true
        end,
        case_insensitive_regex = false,
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰘦 Folds
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Modern fold UI with preview and a custom virtual text summary.
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "VeryLazy",
    config = function()
      local ufo = require("ufo")

      ufo.setup({
        ---Choose fold providers per filetype.
        ---Indent-based folds are faster for large config files; LSP + indent is the default.
        ---@param bufnr number
        ---@param filetype string
        ---@param _ table|nil unused
        ---@return string|string[]
        provider_selector = function(bufnr, filetype, _)
          local ftMap = {
            vim = "indent",
            python = { "indent" },
            git = "",
          }
          return ftMap[filetype] or { "lsp", "indent" }
        end,
        preview = {
          win_config = {
            border = "rounded",
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
        ---Render a collapsed fold as the first line plus a count suffix.
        ---@param virtText table[] original virtual-text chunks
        ---@param lnum number start line of the fold
        ---@param endLnum number end line of the fold
        ---@param width number available window width
        ---@param truncate fun(text: string, width: number): string
        ---@return table[] new virtual-text chunks
        fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
          local newVirtText = {}
          local suffix = (" 󰁂 %d "):format(endLnum - lnum)
          local sufWidth = vim.fn.strdisplaywidth(suffix)
          local targetWidth = width - sufWidth
          local curWidth = 0
          for _, chunk in ipairs(virtText) do
            local chunkText = chunk[1]
            local chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if targetWidth > curWidth + chunkWidth then
              table.insert(newVirtText, chunk)
            else
              chunkText = truncate(chunkText, targetWidth - curWidth)
              local hlGroup = chunk[2]
              table.insert(newVirtText, { chunkText, hlGroup })
              chunkWidth = vim.fn.strdisplaywidth(chunkText)
              if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, "MoreMsg" })
          return newVirtText
        end,
      })

    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰉋 Project Detection
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Detect the project root and keep Telescope/project commands context-aware.
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        manual_mode = false,
        detection_methods = { "pattern", "lsp" },
        patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pyproject.toml", "Cargo.toml" },
        ignore_lsp = {},
        exclude_dirs = { "~/.cargo/*" },
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = "global",
        datapath = vim.fn.stdpath("data"),
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰁨 Diagnostics Panel
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Centralized diagnostics list with auto-preview and auto-close.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({
        modes = {
          diagnostics = {
            auto_open = false,
            auto_close = true,
            auto_preview = true,
            focus = false,
          },
        },
        icons = {
          indent = {
            fold_open = " ",
            fold_closed = " ",
          },
          folder_closed = " ",
          folder_open = " ",
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  --  TODO / FIXME Comments
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Highlight and search actionable comments across the codebase.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({
        signs = true,
        sign_priority = 8,
        keywords = {
          TODO = { icon = " ", color = "todo" },
          FIX = { icon = " ", color = "fix", alt = { "FIXME", "FIXIT", "ISSUE" } },
          BUG = { icon = " ", color = "bug" },
          NOTE = { icon = "󰍨 ", color = "note" },
          INFO = { icon = " ", color = "info" },
          WARN = { icon = " ", color = "warn", alt = { "WARNING", "XXX" } },
          ERROR = { icon = " ", color = "error" },
          PERF = { icon = "󰅒 ", color = "perf" },
          OPTIMIZE = { icon = "󰘦 ", color = "optimize", alt = { "OPTIM", "PERFORMANCE" } },
          HACK = { icon = " ", color = "hack" },
          IMPORTANT = { icon = "󰅾 ", color = "important" },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
          REVIEW = { icon = " ", color = "review" },
          QUESTION = { icon = " ", color = "question" },
          IDEA = { icon = " ", color = "idea" },
          SUCCESS = { icon = " ", color = "success" },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
        merge_keywords = true,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide_bg",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        colors = {
          todo = { "#2563EB" },
          fix = { "#DC2626" },
          bug = { "#B91C1C" },
          note = { "#10B981" },
          info = { "#0891B2" },
          warn = { "#F59E0B" },
          error = { "#EF4444" },
          perf = { "#7C3AED" },
          optimize = { "#8B5CF6" },
          hack = { "#F97316" },
          important = { "#E11D48" },
          test = { "#FF006E" },
          review = { "#0EA5E9" },
          question = { "#8B5CF6" },
          idea = { "#EC4899" },
          success = { "#22C55E" },
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]],
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰌵 Keymap Discovery
  -- ─────────────────────────────────────────────────────────────────────────────

  -- Popup hints for partial key sequences so keymaps stay discoverable.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        preset = "modern",
        delay = 300,
        ---Hide entries that have no description so the popup stays useful.
        ---@param mapping table
        ---@return boolean
        filter = function(mapping)
          return mapping.desc and mapping.desc ~= ""
        end,
        win = {
          no_overlap = true,
          padding = { 1, 2 },
          title = true,
          title_pos = "center",
          zindex = 1000,
        },
        layout = {
          width = { min = 20 },
          spacing = 3,
        },
        triggers = {
          { "<auto>", mode = "nixsoc" },
        },
      })
    end,
  },
}
