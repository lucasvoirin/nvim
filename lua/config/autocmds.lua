-- Set color theme
vim.cmd.colorscheme 'tokyonight-moon'

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Remove line number in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

-- Reload file in buffer if changed have been made
vim.api.nvim_create_autocmd({"BufEnter", "FocusGained"}, {
  callback = function()
    vim.cmd("checktime")
  end,
})

-- Disable LSP diagnostics
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.diagnostic.enable(false)
    end,
})
