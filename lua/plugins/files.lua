--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: files.lua
-- Purpose: Configures file navigation and directory editing plugins.
-- Author: Mohammed
--
-- Plugins:
--   - neo-tree.nvim: project-wide file tree with git/diagnostic hints
--   - oil.nvim: edit the filesystem like a normal buffer
--
-- NOTE: All top-level keymaps live in lua/core/keymaps.lua.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰉋 Neo-tree File Explorer
  -- ─────────────────────────────────────────────────────────────────────────────

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        -- Window picker used by Neo-tree to choose a target window for "open"
        -- when multiple splits are visible.
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        ---Configure nvim-window-picker for predictable window selection.
        config = function()
          require("window-picker").setup({
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              bo = {
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                buftype = { "terminal", "quickfix" },
              },
            },
          })
        end,
      },
    },

    ---Configure Neo-tree appearance, mappings and source behaviour.
    config = function()
      require("neo-tree").setup({
        -- Keep the tree visible when closing the last file so it doesn't steal focus.
        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        -- Don't replace special-purpose windows when opening a file.
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = false,
        default_component_configs = {
          container = { enable_character_fade = true },
          -- Visual tree guides and expand/collapse affordances.
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = true,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "󰜌",
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = { symbol = "[+]", highlight = "NeoTreeModified" },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          -- Keep git glyphs compact but distinct.
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
          file_size = { enabled = true, required_width = 64 },
          type = { enabled = true, required_width = 122 },
          last_modified = { enabled = true, required_width = 88 },
          created = { enabled = true, required_width = 110 },
          symlink_target = { enabled = false },
        },
        window = {
          position = "left",
          width = 40,
          mapping_options = { noremap = true, nowait = true },
          -- Built-in buffer-local mappings. Top-level leader keymaps are in
          -- lua/core/keymaps.lua.
          mappings = {
            ["<space>"] = { "toggle_node", nowait = false },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = { "add", config = { show_path = "none" } },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
            ["i"] = "show_file_details",
          },
        },
        filesystem = {
          -- Hide noisy/generated files and directories without disabling dotfiles globally.
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,
            hide_by_name = {
              ".DS_Store",
              "thumbs.db",
              "node_modules",
            },
            never_show = {
              "__pycache__",
              "venv",
              ".mypy_cache",
              ".pytest_cache",
              ".ruff_cache",
            },
            never_show_by_pattern = {
              "*.pyc",
              "*.pyo",
              "*/__pycache__/*",
            },
          },
          -- Always reveal the current buffer in the tree.
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default",
          -- React to filesystem changes instead of relying on manual refreshes.
          use_libuv_file_watcher = true,
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
            },
          },
        },
        buffers = {
          follow_current_file = { enabled = true, leave_dirs_open = false },
          group_empty_dirs = true,
          show_unloaded = true,
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰉋 Oil Directory Editor
  -- ─────────────────────────────────────────────────────────────────────────────

  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },

    ---Configure Oil to make directory buffers editable with normal-mode verbs.
    config = function()
      require("oil").setup({
        -- Replace netrw so `-` and similar motions open Oil instead.
        default_file_explorer = true,
        columns = { "icon" },
        -- Safer deletes: move to trash instead of unlinking permanently.
        delete_to_trash = true,
        -- Don't prompt for single-file renames or deletes.
        skip_confirm_for_simple_edits = true,
        -- Buffer-local mappings. Top-level leader keymaps are in
        -- lua/core/keymaps.lua.
        keymaps = {
          ["g?"] = { "actions.show_help", mode = "n" },
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true } },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
          ["<C-t>"] = { "actions.select", opts = { tab = true } },
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = { "actions.close", mode = "n" },
          ["<C-l>"] = "actions.refresh",
          ["-"] = { "actions.parent", mode = "n" },
          ["_"] = { "actions.open_cwd", mode = "n" },
          ["`"] = { "actions.cd", mode = "n" },
          ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
          ["gs"] = { "actions.change_sort", mode = "n" },
          ["gx"] = "actions.open_external",
          ["g."] = { "actions.toggle_hidden", mode = "n" },
          ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          -- Keep navigation anchors and the git folder out of the editable list.
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
        win_options = { wrap = true },
      })
    end,
  },
}
