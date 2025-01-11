local floating_buf = nil
local floating_win = nil

function ToggleFloatingTerminal()
  if floating_win and vim.api.nvim_win_is_valid(floating_win) then
    vim.api.nvim_win_close(floating_win, true)
    floating_win = nil
  else
    if not floating_buf or not vim.api.nvim_buf_is_valid(floating_buf) then
      floating_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(floating_buf, "bufhidden", "hide")
      vim.api.nvim_buf_call(floating_buf, function()
        vim.fn.termopen(vim.o.shell)
      end)
    end
    floating_win = vim.api.nvim_open_win(floating_buf, true, {
      relative = "editor",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      col = math.floor(vim.o.columns * 0.1),
      row = math.floor(vim.o.lines * 0.1),
      style = "minimal",
      border = "rounded",
      noautocmd = true,
    })
    vim.api.nvim_win_set_config(floating_win, { zindex = 1500 })
    vim.cmd("startinsert")
  end
end

-- reset terminal on exit
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function(ev)
    if ev.buf == floating_buf then
      if floating_win and vim.api.nvim_win_is_valid(floating_win) then
        vim.api.nvim_win_close(floating_win, true)
      end
      floating_buf = nil
      floating_win = nil
    end
  end,
})

-- keymaps
vim.keymap.set({"n", "i", "t"}, "<c-^>", ToggleFloatingTerminal, { noremap = true, silent = true })
