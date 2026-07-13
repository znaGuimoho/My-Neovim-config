--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: editor.lua
-- Purpose: Configures editing-related plugins (pairing, tags, comments, surround,
--          text objects, movement, split/join, flash navigation, and multicursors).
-- Author: Mohammed
--
-- All plugin keymaps live in lua/core/keymaps.lua unless otherwise noted.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰘧 Pairing & Auto-tags
  -- ─────────────────────────────────────────────────────────────────────────────

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    ---Set up nvim-autopairs with Treesitter-aware rules and bracket-spacing helpers.
    ---@return nil
    config = function()
      local autopairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")

      autopairs.setup({
        check_ts = true,
        ts_config = {
          lua = { "string" },
          python = { "string" },
          javascript = { "template_string" },
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<M-e>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
      })

      -- Add breathing room inside empty bracket pairs: {|} -> { | }
      autopairs.add_rules({
        Rule(" ", " "):with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ "()", "[]", "{}" }, pair)
        end),
        Rule("( ", " )")
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match(".%)") ~= nil
          end)
          :use_key(")"),
        Rule("{ ", " }")
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match(".%}") ~= nil
          end)
          :use_key("}"),
        Rule("[ ", " ]")
          :with_pair(function()
            return false
          end)
          :with_move(function(opts)
            return opts.prev_char:match(".%]") ~= nil
          end)
          :use_key("]"),
      })

    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = { enable_close = true },
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰌵 Comments & Surround
  -- ─────────────────────────────────────────────────────────────────────────────

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    ---Set up Comment.nvim with custom togglers and extra insertion mappings.
    ---@return nil
    config = function()
      require("Comment").setup({
        padding = true,
        sticky = true,
        ignore = nil,
        toggler = {
          line = "<leader>/",
          block = "<leader>?",
        },
        opleader = {
          line = "<leader>/",
          block = "<leader>?",
        },
        extra = {
          above = "<leader>O",
          below = "<leader>o",
          eol = "<leader>A",
        },
        mappings = {
          basic = true,
          extra = true,
        },
      })
    end,
  },

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      -- NOTE: nvim-surround v4 sets its default keymaps automatically, so an empty
      -- setup() opts into them.
      require("nvim-surround").setup({})
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰔱 Text Objects & Movement
  -- ─────────────────────────────────────────────────────────────────────────────

  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    ---Extend mini.ai with Treesitter-backed textobjects for blocks, functions,
    ---classes, and HTML/JSX-style tags.
    ---@return nil
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- block / conditional / loop
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]-$" }, -- tag pairs
        },
      })
    end,
  },

  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    config = function()
      require("mini.move").setup({
        mappings = {
          left = "<M-h>",
          right = "<M-l>",
          down = "<M-j>",
          up = "<M-k>",
          line_left = "<M-h>",
          line_right = "<M-l>",
          line_down = "<M-j>",
          line_up = "<M-k>",
        },
      })
    end,
  },

  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    config = function()
      require("mini.splitjoin").setup({
        mappings = {
          toggle = "gS",
          split = "gk",
          join = "gj",
        },
      })
    end,
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰈔 Flash Navigation
  -- ─────────────────────────────────────────────────────────────────────────────

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
        mode = "exact",
      },
      jump = {
        jumplist = true,
        pos = "start",
        history = false,
        register = false,
        nohlsearch = false,
        autojump = false,
      },
      label = {
        uppercase = false,
        exclude = "",
        current = true,
        after = true,
        before = false,
        style = "overlay",
        reuse = "lowercase",
        distance = true,
        min_pattern_length = 0,
      },
      highlight = {
        backdrop = true,
        matches = true,
        priority = 5000,
      },
      modes = {
        search = { enabled = true },
        char = {
          enabled = true,
          keys = { "f", "F", "t", "T", ";", "," },
          search = { wrap = false },
          highlight = { backdrop = true },
          jump = { register = false },
        },
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" },
          search = { incremental = false },
          label = { before = true, after = true, style = "inline" },
          highlight = { backdrop = false, matches = false },
        },
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────────────────────
  -- 󰌌 Multicursor
  -- ─────────────────────────────────────────────────────────────────────────────

  -- NOTE: Keymaps are defined in lua/core/keymaps.lua under the Editing section.

  {
    "jake-stewart/multicursor.nvim",
    branch = "main",
    event = "VeryLazy",
    config = function()
      require("multicursor-nvim").setup()
    end,
  },
}
