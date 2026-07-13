--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: ui.lua
-- Purpose: Configures UI-related plugins for Neovim.
-- Author: Mohammed
--
-- 󰏖 Plugins covered:
-- - lualine, bufferline, alpha, notify, noice, dressing, scrollbar, neoscroll, dropbar
--
-- NOTE: Keymaps for these plugins are defined in `lua/core/keymaps.lua`.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰔌 Statusline
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    --- Configure the statusline components and global appearance.
    config = function()
      --- Hide optional components on narrow windows.
      --- @return boolean true when the current window is wider than 100 columns
      local hide_in_width = function()
        return vim.fn.winwidth(0) > 100
      end

      local mode = {
        "mode",
        --- Render the mode with a Vim icon and shorten it on small windows.
        --- @param str string The full mode name.
        --- @return string Formatted mode text.
        fmt = function(str)
          return " " .. (hide_in_width() and str or str:sub(1, 1))
        end,
      }

      local filename = {
        "filename",
        -- Show the project-relative path instead of just the file name.
        path = 1,
        symbols = {
          modified = " ●",
          readonly = " ",
          unnamed = "[No Name]",
        },
      }

      local diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = "󰌵 ",
        },
        colored = true,
        update_in_insert = false,
        always_visible = false,
        cond = hide_in_width,
      }

      local diff = {
        "diff",
        colored = true,
        symbols = { added = " ", modified = " ", removed = " " },
        cond = hide_in_width,
      }

      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "alpha", "dashboard", "neo-tree", "Avante" },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { mode },
          lualine_b = { "branch", diff, diagnostics },
          lualine_c = { filename },
          lualine_x = {
            { "encoding", cond = hide_in_width },
            { "fileformat", cond = hide_in_width },
            { "filetype", cond = hide_in_width },
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = { "fugitive", "neo-tree", "lazy", "mason", "trouble" },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰓩 Buffer Tabs
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = {
      "moll/vim-bbye",
      "nvim-tree/nvim-web-devicons",
    },

    --- Configure bufferline with LSP diagnostics and mouse-friendly close actions.
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          themable = true,
          numbers = "none",
          close_command = "Bdelete! %d",
          right_mouse_command = "Bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          buffer_close_icon = "✗",
          close_icon = "",
          modified_icon = "●",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30,
          tab_size = 21,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          --- Build the diagnostic indicator shown next to a buffer tab.
          --- @param count integer Number of diagnostics.
          --- @param level string Diagnostic severity level.
          --- @return string Indicator text with icon and count.
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          color_icons = true,
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          persist_buffer_sort = true,
          separator_style = { "│", "│" },
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          show_tab_indicators = false,
          indicator = { style = "none" },
          sort_by = "insert_at_end",
        },
        highlights = {
          separator = { fg = "#45475a" },
          buffer_selected = { bold = true, italic = false },
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰕮 Dashboard
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    --- Build the startup dashboard with ASCII art and action buttons.
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                    ]],
        [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
        [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
        [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
        [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
        [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
        [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
        [[                                                    ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file", "<cmd>ene<CR>"),
        dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", "  Find text", "<cmd>Telescope live_grep<CR>"),
        dashboard.button("p", "  Projects", "<cmd>Telescope projects<CR>"),
        dashboard.button("s", "  Restore session", [[<cmd>lua require("persistence").load()<cr>]]),
        dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
        dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
      }

      dashboard.section.footer.val = {
        "Neovim — modal editing, modern IDE experience",
      }

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰂚 Notifications
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",

    --- Replace the default notify backend with a styled popup.
    config = function()
      local notify = require("notify")
      notify.setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        background_colour = "#1e1e2e",
        --- Cap notification width to 40% of the editor.
        --- @return integer Maximum width in columns.
        max_width = function()
          return math.floor(vim.o.columns * 0.4)
        end,
        --- Cap notification height to 40% of the editor.
        --- @return integer Maximum height in lines.
        max_height = function()
          return math.floor(vim.o.lines * 0.4)
        end,
        render = "default",
        top_down = true,
      })
      -- Route all vim.notify calls through the styled backend.
      vim.notify = notify
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰘳 Command Line, Messages & Popups
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },

    --- Route LSP messages and cmdline UI through noice for a consistent experience.
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = true,
            auto_open = {
              enabled = true,
              trigger = true,
              luasnip = true,
              throttle = 50,
            },
          },
          hover = { enabled = true },
        },
        presets = {
          bottom_search = true, -- Keep search on the familiar bottom cmdline.
          command_palette = true, -- Group cmdline + popupmenu into a single palette.
          long_message_to_split = true, -- Avoid blocking the UI with long messages.
          inc_rename = false, -- No input dialog for incremental rename.
          lsp_doc_border = true, -- Add borders to hover docs and signature help.
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
          {
            filter = { event = "notify", find = "No information available" },
            skip = true,
          },
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰍜 Input & Selection
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",

    --- Enhance vim.ui.input and vim.ui.select with styled prompts and pickers.
    config = function()
      require("dressing").setup({
        input = {
          enabled = true,
          default_prompt = "Input:",
          title_pos = "left",
          insert_only = false,
          start_in_insert = true,
          border = "rounded",
          relative = "cursor",
          prefer_width = 40,
          width = nil,
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },
        },
        select = {
          enabled = true,
          backend = { "telescope", "nui", "builtin" },
          telescope = require("telescope.themes").get_dropdown({}),
          nui = {
            position = "50%",
            size = nil,
            relative = "editor",
            border = { style = "rounded" },
            buf_options = { swapfile = false, filetype = "DressingSelect" },
            win_options = { winblend = 10 },
            max_width = 80,
            max_height = 40,
            min_width = 40,
            min_height = 10,
          },
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰜜 Scrollbar
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",

    --- Show a scrollbar with diagnostic marks and a visible handle.
    config = function()
      require("scrollbar").setup({
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000,
        max_lines = false,
        handle = {
          text = " ",
          blend = 30,
          color = nil,
          color_nr = nil,
          highlight = "CursorColumn",
          hide_if_all_visible = true,
        },
        marks = {
          Cursor = { text = "•" },
          Search = { color = "#f9e2af" },
          Error = { color = "#f38ba8" },
          Warn = { color = "#fab387" },
          Info = { color = "#89dceb" },
          Hint = { color = "#a6e3a1" },
          Misc = { color = "#cba6f7" },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = false,
          handle = true,
          search = false,
          ale = false,
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰑣 Smooth Scrolling
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",

    --- Enable smooth scrolling for common navigation motions.
    config = function()
      require("neoscroll").setup({
        mappings = {
          "<C-u>",
          "<C-d>",
          "<C-b>",
          "<C-f>",
          "<C-y>",
          "<C-e>",
          "zt",
          "zz",
          "zb",
        },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = "quadratic",
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰋲 Breadcrumbs / Winbar
  -- ─────────────────────────────────────────────────────────────────────────────
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },

    --- Set up the clickable winbar breadcrumb menu.
    config = function()
      local api = require("dropbar.api")

      require("dropbar").setup({
        general = {
          --- Only enable the winbar for normal, non-floating, named buffers.
          --- @param buf integer Buffer handle.
          --- @param win integer Window handle.
          --- @return boolean true when the winbar should be active.
          enable = function(buf, win)
            return vim.api.nvim_win_get_config(win).relative == ""
              and vim.bo[buf].buftype == ""
              and vim.api.nvim_buf_get_name(buf) ~= ""
              and not vim.wo[win].diff
          end,
        },
        menu = {
          preview = false,
          keymaps = {
            --- Open the dropbar picker with the mouse.
            ["<LeftMouse>"] = function()
              local api = require("dropbar.api")
              api.pick()
            end,
            --- Open the selected breadcrumb item under the cursor.
            ["<CR>"] = function()
              local menu = api.get_current_dropbar_menu()
              if not menu then
                return
              end
              local cursor = vim.api.nvim_win_get_cursor(menu.win)
              local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
              if component then
                menu:click_on(component)
              end
            end,
          },
        },
      })
    end,
  },
}
