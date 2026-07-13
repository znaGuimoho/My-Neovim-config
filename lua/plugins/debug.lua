--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: debug.lua
-- Purpose: Configures nvim-dap, adapters, DAP UI, and virtual-text integration.
-- Author: Mohammed
--
-- This file sets up the debug adapter protocol (DAP) ecosystem, including:
--   - Mason-managed debug adapter installation
--   - Adapter definitions for C/C++, Rust, Python, and JavaScript/TypeScript
--   - nvim-dap-ui layouts and automatic open/close behavior
--   - Inline virtual text for current debug values
--   - Diagnostic-style signs for breakpoints and stopped state
--
-- NOTE: All keymaps live in lua/core/keymaps.lua.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
      "Saghen/blink.cmp",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰏖 Mason DAP Bridge
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Ensures debug adapters are installed through Mason without manual setup.
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "python",
          "node2",
          "cppdbg",
          "codelldb",
          "js-debug-adapter",
        },
        automatic_installation = true,
        handlers = {},
      })

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰙨 Adapter Definitions
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Language-agnostic server/executable adapters used by launch configurations.

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = "OpenDebugAD7",
      }

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰙨 Launch Configurations
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Per-language debug profiles. Shared configs are reused for related filetypes.

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          ---Prompts for the executable path relative to the current working directory.
          ---@return string absolute path to the binary to debug
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      dap.configurations.python = {
        {
          type = "debugpy",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          ---Resolves the active Python interpreter for the current project.
          ---Prefers local virtual environments, falling back to the system interpreter.
          ---@return string path to the python executable
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return "/usr/bin/python"
            end
          end,
        },
      }

      dap.configurations.javascript = {
        {
          type = "node2",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }
      dap.configurations.typescript = dap.configurations.javascript

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰒓 DAP UI Configuration
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Defines sidebar/bottom panel layouts, mappings, and floating window styling.

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 40,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 15,
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = { close = { "q", "<Esc>" } },
        },
      })

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰨖 Auto-open / Auto-close Hooks
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Keeps the debug UI in sync with DAP session lifecycle events.

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰙨 Inline Virtual Text
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Renders current variable values directly in the buffer during a debug session.

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = ".*",
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 🎨 Diagnostic Signs
      -- ─────────────────────────────────────────────────────────────────────────────
      -- Visual gutter indicators for breakpoints, log points, and the current frame.

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "DiagnosticHint", linehl = "", numhl = "" })
    end,
  },
}
