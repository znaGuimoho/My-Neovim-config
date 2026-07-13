# Neovim Configuration

A fast, beautiful, modular Neovim setup that keeps Vim's modal, keyboard-first
philosophy while delivering a polished modern IDE experience.

> Built with `lazy.nvim`, `blink.cmp`, `Catppuccin`, `Telescope`, `Neo-tree`,
> `nvim-dap`, and friends.

---

## 📋 Requirements

- [Neovim](https://neovim.io/) >= 0.11.0 (uses `vim.lsp.config` / `vim.lsp.enable`)
- [Git](https://git-scm.com/)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope live grep
- `node` / `npm` for some LSP servers
- Optional: a terminal audio player (`afplay`, `mpv`, `ffplay`, `aplay`, or `paplay`)
  for the custom floating terminal error sound

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua                 # Entry point, session restore, custom commands
└── lua/
    ├── core/
    │   ├── options.lua      # Vim options and global settings
    │   ├── keymaps.lua      # ALL keymaps live here
    │   ├── autocmds.lua     # Autocommands (yank, diagnostics, kitty padding)
    │   └── lazy.lua         # lazy.nvim bootstrap and plugin spec loading
    ├── plugins/
    │   ├── theme.lua        # Catppuccin colorscheme
    │   ├── ui.lua           # Lualine, Bufferline, Alpha, Noice, Notify, etc.
    │   ├── editor.lua       # Autopairs, comments, surround, flash, multicursor
    │   ├── treesitter.lua   # Syntax highlighting, textobjects, rainbow
    │   ├── telescope.lua    # Fuzzy finder and extensions
    │   ├── files.lua        # Neo-tree and Oil
    │   ├── lsp.lua          # Mason + LSP servers
    │   ├── completion.lua   # blink.cmp + LuaSnip
    │   ├── formatting.lua   # conform.nvim
    │   ├── linting.lua      # nvim-lint
    │   ├── git.lua          # Gitsigns, Diffview, LazyGit
    │   ├── terminal.lua     # Toggleterm
    │   ├── debug.lua        # nvim-dap + dap-ui
    │   ├── qol.lua          # Sessions, undo tree, folds, which-key, etc.
    │   └── docs.lua         # Markdown rendering & comment highlights
    └── util/
        └── terminal.lua     # Custom floating terminal with audio feedback
```

---

## 🔌 Plugins

| Category | Plugins |
|----------|---------|
| **Theme** | catppuccin |
| **Status / Tabs** | lualine, bufferline |
| **Dashboard / Notify** | alpha-nvim, nvim-notify, noice, dressing |
| **Navigation** | telescope, flash, dropbar |
| **Files** | neo-tree, oil |
| **LSP** | nvim-lspconfig, mason, mason-lspconfig, mason-tool-installer, fidget |
| **Completion** | blink.cmp, LuaSnip, friendly-snippets, blink-ripgrep |
| **Formatting** | conform.nvim |
| **Linting** | nvim-lint |
| **Git** | gitsigns, diffview, lazygit.nvim |
| **Terminal** | toggleterm.nvim |
| **Debug** | nvim-dap, nvim-dap-ui, nvim-dap-virtual-text, mason-nvim-dap |
| **Editing** | nvim-autopairs, nvim-ts-autotag, Comment.nvim, nvim-surround, mini.ai, mini.move, mini.splitjoin, multicursor.nvim |
| **Treesitter** | nvim-treesitter, nvim-treesitter-textobjects, rainbow-delimiters.nvim |
| **Quality of Life** | persistence, undotree, vim-illuminate, nvim-ufo, project.nvim, trouble, todo-comments, which-key, neoscroll, nvim-scrollbar |
| **Documentation** | markview.nvim (Markdown rendering), mini.hipatterns (color/priority tag highlights) |

---

## ⚡ Installation

Back up your existing config first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

Clone this repo:

```bash
git clone https://github.com/znaGuimoho/My-Neovim-config.git ~/.config/nvim
```

Open Neovim — plugins will install automatically on first launch:

```bash
nvim
```

Mason will also install configured language servers, formatters, and linters
in the background.

---

## ⌨️ Key Mappings

`<leader>` is `Space`.

All keymaps are defined in `lua/core/keymaps.lua`.

### Leader conventions

| Prefix | Category |
|--------|----------|
| `<leader>f` | Files / Find (Telescope) |
| `<leader>e` | Explorer (Neo-tree / Oil) |
| `<leader>g` | Git |
| `<leader>h` | Git Hunk |
| `<leader>c` | Code (LSP / format / diagnostics) |
| `<leader>t` | Terminal / Todo / Toggle |
| `<leader>s` | Search (Telescope) |
| `<leader>b` | Buffers |
| `<leader>w` | Windows |
| `<leader>d` | Debug |
| `<leader>u` | UI toggles |
| `<leader>x` | Trouble / quickfix |
| `<leader>q` | Quit / session |

### Common mappings

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>e` | Toggle Neo-tree |
| `-` | Open parent directory (Oil) |
| `<leader>gg` | Open LazyGit |
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation / peek fold |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cf` | Format file or range |
| `<leader>tt` | Toggle floating terminal |
| `<leader>xx` | Diagnostics (Trouble) |

Press `<leader>` and wait briefly for `which-key` to show all available
mappings with descriptions.

---

## 📝 Documentation Style

This configuration uses a consistent documentation style across every Lua file:

- **File headers** with filename, purpose, and author.
- **Nerd Font icons** in section separators (e.g. `󰘧 General`, ` LSP`, ` Terminal`).
- **Markdown-style comments** with headings, lists, blockquotes, and code blocks.
- **Colored comment keywords** via `todo-comments.nvim`:
  `TODO`, `FIX`, `BUG`, `NOTE`, `INFO`, `WARN`, `ERROR`, `PERF`, `OPTIMIZE`,
  `HACK`, `IMPORTANT`, `TEST`, `REVIEW`, `QUESTION`, `IDEA`, `SUCCESS`.
- **Custom highlights** for tags like `[RED]`, `[GREEN]`, `[BLUE]`, `[YELLOW]`,
  `HIGH PRIORITY`, `LOW PRIORITY`, `OPTIONAL`, and `EXPERIMENTAL`.
- **Markdown rendering** inside buffers and comments via `markview.nvim`.

---

## 🙏 Inspiration

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [LazyVim](https://github.com/LazyVim/LazyVim)
- The Neovim community

---

## 📄 License

MIT — do whatever you want with this.
