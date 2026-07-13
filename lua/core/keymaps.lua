--[[
--══════════════════════════════════════════════════════════════════════════════
-- File: keymaps.lua
-- Purpose: Centralizes every Neovim keymap so plugin files stay mapping-free.
-- Author: Mohammed
--
-- Rules:
-- - All mappings are defined here.
-- - No plugin file defines its own mappings.
-- - Every mapping has a descriptive `desc` field.
-- - Plugin functions are wrapped so plugins are loaded lazily on first use.
--
-- Convention:
--   <leader>f  = Files / Find (Telescope)
--   <leader>e  = Explorer (Neo-tree / Oil)
--   <leader>g  = Git
--   <leader>h  = Git Hunk
--   <leader>c  = Code (LSP / format / diagnostics)
--   <leader>t  = Terminal / Todo / Toggle
--   <leader>s  = Search (Telescope)
--   <leader>b  = Buffers
--   <leader>w  = Windows
--   <leader>d  = Debug
--   <leader>u  = UI toggles
--   <leader>x  = Trouble / quickfix
--   <leader>q  = Quit / close
--══════════════════════════════════════════════════════════════════════════════
--]]

local map = vim.keymap.set

--- Build keymap options with a description.
--- Keeps option tables consistent and avoids repeating `noremap` / `silent`.
--- @param desc string The description shown in which-key / keymap help.
--- @return table opts `noremap`, `silent`, and `desc` options.
local function desc_opts(desc)
  return { noremap = true, silent = true, desc = desc }
end

--- Wrap a callback so the requiring plugin is loaded only on first use.
--- This keeps startup fast: plugins are not loaded just because this file is sourced.
--- @param fn function Callback that requires and calls into a plugin.
--- @return function wrapped Thunk that invokes `fn` when the keymap is triggered.
local function lazy(fn)
  return function()
    fn()
  end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰘧 General
-- ─────────────────────────────────────────────────────────────────────────────

-- Space is used as the global leader, so unbind its default behavior.
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Leader key placeholder" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all files" })
map("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>qQ", "<cmd>qa<CR>", { desc = "Quit all" })
map("n", "<leader>qx", "<cmd>x<CR>", { desc = "Save and quit" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- U is unused in normal mode and easier to reach than <C-r>.
map("n", "U", "<C-r>", { desc = "Redo" })

-- Avoid polluting the default register with single-character deletes.
map("n", "x", '"_x', desc_opts("Delete character without yanking"))

-- Keep the cursor centered so large jumps are less disorienting.
map("n", "<C-d>", "<C-d>zz", desc_opts("Scroll down and center cursor"))
map("n", "<C-u>", "<C-u>zz", desc_opts("Scroll up and center cursor"))
map("n", "n", "nzzzv", desc_opts("Next search result and center"))
map("n", "N", "Nzzzv", desc_opts("Previous search result and center"))

-- Re-select the selection after indenting so it can be adjusted repeatedly.
map("v", "<", "<gv", desc_opts("Indent left (stay visual)"))
map("v", ">", ">gv", desc_opts("Indent right (stay visual)"))

-- Paste over visual selection without overwriting the last yanked text.
map("v", "p", '"_dP', desc_opts("Paste without replacing yank"))

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join lines while preserving the cursor position.
map("n", "J", "mzJ`z", desc_opts("Join lines without moving cursor"))

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle line wrap" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰈔 Buffers
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>bd", "<cmd>Bdelete!<CR>", { desc = "Close buffer" })
map("n", "<leader>bD", "<cmd>%bd|e#|bd#<CR>", { desc = "Close all other buffers" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰉋 Windows
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<leader>wv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>wh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>we", "<C-w>=", { desc = "Equalize window sizes" })
map("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close other windows" })

-- Arrow keys are otherwise unused for movement, so use them for split resizing.
map("n", "<Up>", "<cmd>resize -2<CR>", desc_opts("Resize window taller"))
map("n", "<Down>", "<cmd>resize +2<CR>", desc_opts("Resize window shorter"))
map("n", "<Left>", "<cmd>vertical resize -2<CR>", desc_opts("Resize window narrower"))
map("n", "<Right>", "<cmd>vertical resize +2<CR>", desc_opts("Resize window wider"))

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰓩 Tabs
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tf", "<cmd>tabfirst<CR>", { desc = "First tab" })
map("n", "<leader>tl", "<cmd>tablast<CR>", { desc = "Last tab" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰉋 Files / Explorer
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>e", lazy(function()
  require("neo-tree.command").execute({ toggle = true, position = "left" })
end), { desc = "Toggle file explorer (Neo-tree)" })

map("n", "<leader>E", lazy(function()
  require("neo-tree.command").execute({ toggle = true, position = "float" })
end), { desc = "Toggle floating file explorer" })

map("n", "<leader>er", lazy(function()
  require("neo-tree.command").execute({ reveal = true, position = "left" })
end), { desc = "Reveal current file in explorer" })

map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory (Oil)" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰈔 Telescope
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader><space>", lazy(function()
  require("telescope.builtin").buffers()
end), { desc = "Find open buffers" })

map("n", "<leader>ff", lazy(function()
  require("telescope.builtin").find_files()
end), { desc = "Find files" })

map("n", "<leader>fF", lazy(function()
  require("telescope.builtin").find_files({ hidden = true, no_ignore = true })
end), { desc = "Find files (include hidden/ignored)" })

map("n", "<leader>fg", lazy(function()
  require("telescope.builtin").live_grep()
end), { desc = "Live grep" })

map("n", "<leader>fw", lazy(function()
  require("telescope.builtin").grep_string()
end), { desc = "Search word under cursor" })

map("n", "<leader>fr", lazy(function()
  require("telescope.builtin").oldfiles()
end), { desc = "Recent files" })

map("n", "<leader>fR", lazy(function()
  require("telescope.builtin").resume()
end), { desc = "Resume last search" })

map("n", "<leader>fh", lazy(function()
  require("telescope.builtin").help_tags()
end), { desc = "Help tags" })

map("n", "<leader>fc", lazy(function()
  require("telescope.builtin").commands()
end), { desc = "Commands" })

map("n", "<leader>fk", lazy(function()
  require("telescope.builtin").keymaps()
end), { desc = "Keymaps" })

map("n", "<leader>fd", lazy(function()
  require("telescope.builtin").diagnostics()
end), { desc = "Diagnostics" })

map("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOs" })
map("n", "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>", { desc = "Find TODO/FIX" })

map("n", "<leader>fb", lazy(function()
  require("telescope.builtin").buffers()
end), { desc = "Buffers" })

map("n", "<leader>fp", lazy(function()
  require("telescope").extensions.projects.projects()
end), { desc = "Projects" })

map("n", "<leader>f/", lazy(function()
  require("telescope.builtin").current_buffer_fuzzy_find(
    require("telescope.themes").get_dropdown({ previewer = false })
  )
end), { desc = "Fuzzy find in current buffer" })

-- ─────────────────────────────────────────────────────────────────────────────
--  Git
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })

map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diff view" })
map("n", "<leader>gD", "<cmd>DiffviewClose<CR>", { desc = "Close diff view" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "File history" })

map("n", "<leader>gf", lazy(function()
  require("telescope.builtin").git_files()
end), { desc = "Git files" })

map("n", "<leader>gc", lazy(function()
  require("telescope.builtin").git_commits()
end), { desc = "Git commits" })

map("n", "<leader>gC", lazy(function()
  require("telescope.builtin").git_bcommits()
end), { desc = "Git commits for current file" })

map("n", "<leader>gb", lazy(function()
  require("telescope.builtin").git_branches()
end), { desc = "Git branches" })

map("n", "<leader>gs", lazy(function()
  require("telescope.builtin").git_status()
end), { desc = "Git status" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰊢 Git Hunk
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "]h", lazy(function()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    gs.nav_hunk("next")
  end
end), { desc = "Next hunk" })

map("n", "[h", lazy(function()
  local gs = package.loaded.gitsigns
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    gs.nav_hunk("prev")
  end
end), { desc = "Previous hunk" })

map("n", "<leader>hs", lazy(function()
  package.loaded.gitsigns.stage_hunk()
end), { desc = "Stage hunk" })

map("v", "<leader>hs", lazy(function()
  package.loaded.gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end), { desc = "Stage hunk" })

map("n", "<leader>hr", lazy(function()
  package.loaded.gitsigns.reset_hunk()
end), { desc = "Reset hunk" })

map("v", "<leader>hr", lazy(function()
  package.loaded.gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end), { desc = "Reset hunk" })

map("n", "<leader>hS", lazy(function()
  package.loaded.gitsigns.stage_buffer()
end), { desc = "Stage buffer" })

map("n", "<leader>hR", lazy(function()
  package.loaded.gitsigns.reset_buffer()
end), { desc = "Reset buffer" })

map("n", "<leader>hu", lazy(function()
  package.loaded.gitsigns.undo_stage_hunk()
end), { desc = "Undo stage hunk" })

map("n", "<leader>hp", lazy(function()
  package.loaded.gitsigns.preview_hunk()
end), { desc = "Preview hunk" })

map("n", "<leader>hd", lazy(function()
  package.loaded.gitsigns.diffthis()
end), { desc = "Diff this" })

map("n", "<leader>hb", lazy(function()
  package.loaded.gitsigns.toggle_current_line_blame()
end), { desc = "Toggle current line blame" })

map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })

-- ─────────────────────────────────────────────────────────────────────────────
--  LSP / Language Server
-- ─────────────────────────────────────────────────────────────────────────────

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    --- Attach an LSP-aware keymap to the current buffer with a prefixed description.
    --- @param mode string|table Vim mode(s) for the mapping.
    --- @param keys string Key sequence.
    --- @param func function|string Action to execute.
    --- @param desc string Short description (will be prefixed with "LSP: ").
    local bmap = function(mode, keys, func, desc)
      map(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
    end

    bmap("n", "gd", lazy(function()
      require("telescope.builtin").lsp_definitions()
    end), "Go to definition")

    bmap("n", "gr", lazy(function()
      require("telescope.builtin").lsp_references()
    end), "Go to references")

    bmap("n", "gI", lazy(function()
      require("telescope.builtin").lsp_implementations()
    end), "Go to implementation")

    bmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")

    bmap("n", "K", vim.lsp.buf.hover, "Hover documentation")

    bmap("n", "<leader>cd", lazy(function()
      require("telescope.builtin").lsp_type_definitions()
    end), "Type definition")

    bmap("n", "<leader>cs", lazy(function()
      require("telescope.builtin").lsp_document_symbols()
    end), "Document symbols")

    bmap("n", "<leader>cS", lazy(function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end), "Workspace symbols")

    bmap("n", "<leader>cr", vim.lsp.buf.rename, "Rename")

    bmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

    bmap("n", "<leader>cI", "<cmd>LspInfo<CR>", "LSP info")

    bmap("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
    bmap("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
    bmap("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "List workspace folders")

    -- Only bind inlay hints when the server advertises support for them.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      bmap("n", "<leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
      end, "Toggle inlay hints")
    end

    -- Highlight symbol references under the cursor when the server supports it.
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = bufnr })
        end,
      })
    end

    -- Prefer conform.nvim for formatting but fall back to the LSP when it is unavailable.
    bmap({ "n", "v" }, "<leader>cf", lazy(function()
      require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 3000 })
    end), "Format file or range")
  end,
})

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰁨 Code / Diagnostics
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>ci", "<cmd>ConformInfo<CR>", { desc = "Conform info" })

map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics (Trouble)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer diagnostics (Trouble)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", { desc = "Symbols (Trouble)" })
map("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", { desc = "LSP refs/defs (Trouble)" })
map("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>", { desc = "Location list (Trouble)" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Quickfix list (Trouble)" })

map("n", "[x", lazy(function()
  require("trouble").prev({ skip_groups = true, jump = true })
end), { desc = "Previous trouble item" })

map("n", "]x", lazy(function()
  require("trouble").next({ skip_groups = true, jump = true })
end), { desc = "Next trouble item" })

map("n", "]t", lazy(function()
  require("todo-comments").jump_next()
end), { desc = "Next TODO comment" })

map("n", "[t", lazy(function()
  require("todo-comments").jump_prev()
end), { desc = "Previous TODO comment" })

map("n", "<leader>xt", "<cmd>TodoTrouble<CR>", { desc = "TODOs in Trouble" })

-- ─────────────────────────────────────────────────────────────────────────────
--  Terminal
-- ─────────────────────────────────────────────────────────────────────────────

map("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map({ "n", "t" }, "<leader>tt", "<cmd>ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
map({ "n", "t" }, "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map({ "n", "t" }, "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
map("n", "<leader>tf", "<cmd>FolwtingCommand<CR>", { desc = "Toggle custom floating terminal" })
map("n", "<leader>tn", "<cmd>ToggleTermToggleAll<CR>", { desc = "Toggle all terminals" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰙨 Debug
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>db", lazy(function()
  require("dap").toggle_breakpoint()
end), { desc = "Toggle breakpoint" })

map("n", "<leader>dB", lazy(function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end), { desc = "Conditional breakpoint" })

map("n", "<leader>dc", lazy(function()
  require("dap").continue()
end), { desc = "Continue / start debugging" })

map("n", "<leader>di", lazy(function()
  require("dap").step_into()
end), { desc = "Step into" })

map("n", "<leader>do", lazy(function()
  require("dap").step_over()
end), { desc = "Step over" })

map("n", "<leader>dO", lazy(function()
  require("dap").step_out()
end), { desc = "Step out" })

map("n", "<leader>dr", lazy(function()
  require("dap").repl.toggle()
end), { desc = "Toggle REPL" })

map("n", "<leader>du", lazy(function()
  require("dapui").toggle()
end), { desc = "Toggle debug UI" })

map("n", "<leader>dt", lazy(function()
  require("dap").terminate()
end), { desc = "Terminate debugging" })

map("n", "<leader>dk", lazy(function()
  require("dap.ui.widgets").hover()
end), { desc = "Hover variable (debug)" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 🎨 UI Toggles
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>un", lazy(function()
  require("notify").dismiss({ pending = true, silent = true })
end), { desc = "Dismiss notifications" })

map("n", "<leader>ui", lazy(function()
  require("lualine").hide()
end), { desc = "Toggle statusline" })

map("n", "<leader>ub", "<cmd>BufferLineTogglePin<CR>", { desc = "Pin/unpin buffer" })

map("n", "<leader>uT", lazy(function()
  require("telescope.builtin").colorscheme({ enable_preview = true })
end), { desc = "Pick colorscheme" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰌵 Editing
-- ─────────────────────────────────────────────────────────────────────────────

map({ "n", "x", "o" }, "s", lazy(function()
  require("flash").jump()
end), { desc = "Flash jump" })

map({ "n", "x", "o" }, "S", lazy(function()
  require("flash").treesitter()
end), { desc = "Flash treesitter" })

map("o", "r", lazy(function()
  require("flash").remote()
end), { desc = "Remote flash" })

map({ "o", "x" }, "R", lazy(function()
  require("flash").treesitter_search()
end), { desc = "Treesitter search" })

map("c", "<C-s>", lazy(function()
  require("flash").toggle()
end), { desc = "Toggle flash search" })

map("n", "<leader>uU", "<cmd>UndotreeToggle<CR>", { desc = "Toggle undo tree" })

map({ "n", "v" }, "<leader>mn", lazy(function()
  require("multicursor-nvim").matchAddCursor(1)
end), { desc = "Add cursor to next match" })

map({ "n", "v" }, "<leader>mN", lazy(function()
  require("multicursor-nvim").matchAddCursor(-1)
end), { desc = "Add cursor to previous match" })

map({ "n", "v" }, "<leader>mA", lazy(function()
  require("multicursor-nvim").matchAllAddCursors()
end), { desc = "Add cursors to all matches" })

map("n", "<leader>mx", lazy(function()
  require("multicursor-nvim").clearCursors()
end), { desc = "Clear extra cursors" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰄛 Quality of Life
-- ─────────────────────────────────────────────────────────────────────────────

map("n", "<leader>qs", lazy(function()
  require("persistence").load()
end), { desc = "Restore session" })

map("n", "<leader>qS", lazy(function()
  require("persistence").select()
end), { desc = "Select session" })

map("n", "<leader>ql", lazy(function()
  require("persistence").load({ last = true })
end), { desc = "Restore last session" })

map("n", "zR", lazy(function()
  require("ufo").openAllFolds()
end), { desc = "Open all folds" })

map("n", "zM", lazy(function()
  require("ufo").closeAllFolds()
end), { desc = "Close all folds" })

map("n", "zr", lazy(function()
  require("ufo").openFoldsExceptKinds()
end), { desc = "Open folds except kinds" })

map("n", "zm", lazy(function()
  require("ufo").closeFoldsWith()
end), { desc = "Close folds with" })

map("n", "K", lazy(function()
  local winid = require("ufo").peekFoldedLinesUnderCursor()
  if not winid then
    vim.lsp.buf.hover()
  end
end), { desc = "Peek fold or LSP hover" })

-- ─────────────────────────────────────────────────────────────────────────────
-- 󰏖 HTML Snippets
-- ─────────────────────────────────────────────────────────────────────────────

--- Set up buffer-local HTML auto-expansion mappings.
--- Preserved from the previous configuration for quick tag insertion.
local function setup_html_keymaps()
  local tag_opts = function(tag)
    return { noremap = true, silent = true, buffer = true, desc = "Insert <" .. tag .. "> tag" }
  end
  local tags = {
    "div", "span", "p", "h1", "h2", "h3", "h4", "h5", "h6",
    "section", "article", "header", "footer", "nav", "main", "aside",
    "ul", "ol", "li", "table", "tr", "td", "th", "thead", "tbody",
    "form", "button", "a", "strong", "em", "code", "pre", "label",
    "input", "textarea", "select", "option",
  }

  for _, tag in ipairs(tags) do
    map(
      "i",
      "<" .. tag .. ">",
      "<" .. tag .. "></" .. tag .. ">" .. string.rep("<Left>", #tag + 3),
      tag_opts(tag)
    )
  end

  local snippet_opts = function(desc)
    return { noremap = true, silent = true, buffer = true, desc = desc }
  end

  map("i", "<C-h>d", "<div></div><Left><Left><Left><Left><Left><Left>", snippet_opts("HTML div snippet"))
  map("i", "<C-h>s", "<span></span><Left><Left><Left><Left><Left><Left><Left><Left>", snippet_opts("HTML span snippet"))
  map("i", "<C-h>p", "<p></p><Left><Left><Left><Left>", snippet_opts("HTML paragraph snippet"))
  map("i", "<C-h>a", '<a href=""></a><Left><Left><Left><Left><Left><Left><Left><Left>', snippet_opts("HTML anchor snippet"))
  map("i", "<C-h>i", '<img src="" alt="" /><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>', snippet_opts("HTML image snippet"))
  map("i", "<C-h>b", "<button></button><Left><Left><Left><Left><Left><Left><Left><Left><Left>", snippet_opts("HTML button snippet"))
  map("i", "<C-h>h1", "<h1></h1><Left><Left><Left><Left><Left>", snippet_opts("HTML h1 snippet"))
  map("i", "<C-h>ul", "<ul><CR><li></li><CR></ul><Esc>kA<Left><Left><Left><Left><Left>", snippet_opts("HTML unordered list snippet"))
  map("i", "<C-h>c", 'class=""<Left>', snippet_opts("HTML class attribute"))
  map("i", "<C-h>I", 'id=""<Left>', snippet_opts("HTML id attribute"))
  map("i", "<C-h>/", "<!-- --><Left><Left><Left><Left>", snippet_opts("HTML comment"))
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "htmldjango" },
  callback = setup_html_keymaps,
})
