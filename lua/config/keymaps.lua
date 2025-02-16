-- Which-key
require 'which-key'.add({
  { "<leader>o", "<CMD>lua require('oil').toggle_float()<CR>", desc = "Oil"},
  { "<leader>g", "<CMD>lua Snacks.lazygit.open(opts)<CR>", desc = "Lazygit"},
  { "<leader>;", "<CMD>lua Snacks.dashboard.open()<CR>", desc = "Dashboard"},
  { "<leader>a", "<CMD>AerialToggle float<CR>", desc = "Aerial"},
  { "<leader>n", "<CMD>AerialNavToggle<CR>", desc = "Navigation"},
  { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>f", group = "Find"},
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
  { "<leader>fr", "<CMD>Telescope zotero<CR>", desc = "Zotero Reference"},
  { "<leader>fe", "<cmd>lua require('swenv.api').pick_venv()<cr>", desc = "Python Env" },
  { "<leader>fc", "<cmd>lua require'telescope.builtin'.find_files {cwd = vim.fn.stdpath 'config'}<cr>", desc = "Config" },
  { "<leader>t", group = "Toggle"},
})

-- Snacks Toggle
Snacks.toggle.option("background", { off = "dark", on = "light" , name = "Light Background"}):map("<leader>tb")
Snacks.toggle.diagnostics():map("<leader>td")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tl")
Snacks.toggle.zen():map("<leader>tz")

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", { silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { silent = true })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { silent = true })

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')
vim.keymap.set('n','<C-Z>','')


-- Windows navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
