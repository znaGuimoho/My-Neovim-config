--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: lsp.lua
-- Purpose: Configures Language Server Protocol support, server installation,
--          capabilities, and per-server settings.
-- Author: Mohammed
--
-- - Uses Mason plus mason-tool-installer to keep servers/tools present.
-- - Capabilities are enhanced by blink.cmp for completion.
-- - Buffer-local LSP keymaps are registered from lua/core/keymaps.lua via LspAttach.
--══════════════════════════════════════════════════════════════════════════════
--]]

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", config = true },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = { notification = { window = { winblend = 0 } } } },
      "Saghen/blink.cmp",
    },

    -- ─────────────────────────────────────────────────────────────────────────────
    -- 󰏖 Plugin Setup
    -- ─────────────────────────────────────────────────────────────────────────────

    --- Installs, configures, and enables all language servers.
    --- LSP settings are applied per-server and capabilities are extended with blink.cmp.
    config = function()
      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰘧 Mason Tool Installer
      -- ─────────────────────────────────────────────────────────────────────────────

      -- Keep language servers, formatters, and linters in sync across machines.
      local ensure_installed = {
        -- Language servers managed by Mason
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "docker_compose_language_service",
        "gopls",
        "html",
        "jdtls",
        "jsonls",
        "lua_ls",
        "marksman",
        "basedpyright",
        "ruff",
        "rust_analyzer",
        "sqlls",
        "tailwindcss",
        "terraformls",
        "ts_ls",
        "yamlls",
        -- Formatters and linters managed by Mason
        "black",
        "eslint_d",
        "isort",
        "prettier",
        "shfmt",
        "stylua",
      }

      require("mason-tool-installer").setup({
        ensure_installed = ensure_installed,
        auto_update = false,
        run_on_start = true,
      })

      -- ─────────────────────────────────────────────────────────────────────────────
      --  Server Settings
      -- ─────────────────────────────────────────────────────────────────────────────

      -- Per-server overrides beyond Mason defaults.
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
              },
              diagnostics = {
                globals = { "vim" },
                disable = { "missing-fields" },
              },
              format = { enable = false }, -- Use conform/stylua instead
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = true,
              disableLanguageServices = false,
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
              },
            },
          },
        },
        ruff = {},
        html = { filetypes = { "html", "twig", "hbs", "templ" } },
        cssls = {},
        ts_ls = {},
        bashls = {},
        jsonls = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        marksman = {},
        clangd = {},
        jdtls = {},
        gopls = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
            },
          },
        },
        dockerls = {},
        docker_compose_language_service = {},
        terraformls = {},
        sqlls = {},
        tailwindcss = {},
      }

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰅴 Capabilities
      -- ─────────────────────────────────────────────────────────────────────────────

      -- Extend Neovim's defaults with blink.cmp so completion works out of the box.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, blink = pcall(require, "blink.cmp")
      if ok then
        capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
      end

      -- ─────────────────────────────────────────────────────────────────────────────
      -- 󰒡 Enable Servers
      -- ─────────────────────────────────────────────────────────────────────────────

      -- Register every server with Neovim's native LSP client.
      for server, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend("force", {}, capabilities, cfg.capabilities or {})
        vim.lsp.config(server, cfg)
        vim.lsp.enable(server)
      end
    end,
  },
}
