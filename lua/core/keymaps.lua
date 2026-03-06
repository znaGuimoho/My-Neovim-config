vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", opts)
vim.keymap.set("n", "x", "_x", opts)
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

--closing things that can open!!!!
vim.keymap.set("i", "(", "()<Left>", opts)
vim.keymap.set("i", "[", "[]<Left>", opts)
vim.keymap.set("i", "{", "{}<Left>", opts)
vim.keymap.set("i", '"', '""<Left>', opts)
vim.keymap.set("i", "'", "''<Left>", opts)
vim.keymap.set("i", "`", "``<Left>", opts)
vim.keymap.set("i", "<", "<><Left>", opts)

-- HTML auto-closing tags (only for HTML, JSX, TSX, XML files)
local function setup_html_keymaps()
	local html_opts = { noremap = true, silent = true, buffer = true }

	-- Auto-close common HTML tags when you type the opening tag and press Enter
	-- Example: type <div> and press Enter, it creates:
	-- <div>
	--   |cursor here
	-- </div>

	-- For div tags
	vim.keymap.set("i", "<div>", "<div></div><Left><Left><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("i", "div>", "div><CR></div><Esc>O", html_opts)

	-- For common HTML tags with auto-close and proper indentation
	local tags = {
		"div",
		"span",
		"p",
		"h1",
		"h2",
		"h3",
		"h4",
		"h5",
		"h6",
		"section",
		"article",
		"header",
		"footer",
		"nav",
		"main",
		"aside",
		"ul",
		"ol",
		"li",
		"table",
		"tr",
		"td",
		"th",
		"thead",
		"tbody",
		"form",
		"button",
		"a",
		"strong",
		"em",
		"code",
		"pre",
		"label",
		"input",
		"textarea",
		"select",
		"option",
	}

	for _, tag in ipairs(tags) do
		-- When you type <tag and press >, it auto-completes to <tag>|</tag>
		vim.keymap.set(
			"i",
			"<" .. tag .. ">",
			"<" .. tag .. "></" .. tag .. "><Left><Left><Left><Left>" .. string.rep("<Left>", #tag),
			html_opts
		)
	end

	-- Quick HTML snippets with leader key in insert mode
	vim.keymap.set("i", "<C-h>d", "<div></div><Left><Left><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("i", "<C-h>s", "<span></span><Left><Left><Left><Left><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("i", "<C-h>p", "<p></p><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("i", "<C-h>a", '<a href=""></a><Left><Left><Left><Left><Left><Left><Left><Left>', html_opts)
	vim.keymap.set(
		"i",
		"<C-h>i",
		'<img src="" alt="" /><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>',
		html_opts
	)
	vim.keymap.set("i", "<C-h>b", "<button></button><Left><Left><Left><Left><Left><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("i", "<C-h>h1", "<h1></h1><Left><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("i", "<C-h>ul", "<ul><CR><li></li><CR></ul><Esc>kA<Left><Left><Left><Left><Left>", html_opts)

	-- Quick class and id attributes
	vim.keymap.set("i", "<C-h>c", 'class=""<Left>', html_opts)
	vim.keymap.set("i", "<C-h>I", 'id=""<Left>', html_opts)

	-- HTML comment
	vim.keymap.set("i", "<C-h>/", "<!-- --><Left><Left><Left><Left>", html_opts)
	vim.keymap.set("n", "<leader>/", "I<!-- <Esc>A --><Esc>", html_opts)
	vim.keymap.set("v", "<leader>/", "<Esc>`<i<!-- <Esc>`>la --><Esc>", html_opts)
end

-- Auto-setup HTML keymaps for HTML files only
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html" },
	callback = setup_html_keymaps,
})

--helpers for the window movements!!!!!
vim.keymap.set("n", "<leader>l", "<C-w>l", opts)
vim.keymap.set("n", "<leader>h", "<C-w>h", opts)

--helpers for the window splitting!!!!
vim.keymap.set("n", "<leader>v", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", opts) -- close current split window

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<C-i>", "<C-i>", opts) -- to restore jump forward
vim.keymap.set("n", "<leader>x", ":Bdelete!<CR>", opts) -- close buffer
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", opts) -- new buffer

--floating Terminal key maps
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", opts)
vim.keymap.set({ "n", "t" }, "<leader>ft", ":FolwtingCommand<CR>", opts)
