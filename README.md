# 🛠️ My Neovim Config

My personal Neovim configuration — a setup I've built and continue to refine for my own workflow.

> Feel free to explore, fork, or borrow whatever is useful to you.

---

## 📋 Requirements

- [Neovim](https://neovim.io/) >= 0.9.0
- [Git](https://git-scm.com/)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- `ripgrep` — for Telescope live grep
- `node` / `npm` — for some LSP servers

---

## 📁 Structure

```
~/.config/nvim/
├── init.lua              # Entry point
└── lua/
    ├── config/           # Core settings (options, keymaps, autocmds)
    └── plugins/          # Plugin specs and configurations
```

---

## 🔌 Plugins

| Plugin | Purpose |
|--------|---------|
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin manager |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP support |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocompletion |
| [mason.nvim](https://github.com/williamboman/mason.nvim) | LSP/DAP/linter installer |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | File explorer |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Status line |

> Update this table to match your actual plugins.

---

## ⚡ Installation

**Back up your existing config first:**

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

**Clone this repo:**

```bash
git clone https://github.com/znaGuimoho/My-Neovim-config.git ~/.config/nvim
```

**Open Neovim** — plugins will install automatically on first launch:

```bash
nvim
```

---

## ⌨️ Key Mappings

`<leader>` is set to `Space`.

| Keymap | Action |
|--------|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fg` | Live grep (Telescope) |
| `<leader>e` | Toggle file explorer |
| `<leader>q` | Close buffer |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `<leader>ca` | Code action |

> Update this table to match your actual keymaps.

---

## 📸 Screenshots

<!-- Add screenshots here -->
> Coming soon.

---

## 🙏 Inspiration

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
- [LazyVim](https://github.com/LazyVim/LazyVim)
- The Neovim community ❤️

---

## 📄 License

MIT — do whatever you want with this.
