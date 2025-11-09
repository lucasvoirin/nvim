local M = {}

local terminal_buf = nil
local terminal_win = nil
M.term_chan = nil

function M.ToggleVsplitTerminal()
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    vim.api.nvim_win_close(terminal_win, true)
    terminal_win = nil
  else
    if not terminal_buf or not vim.api.nvim_buf_is_valid(terminal_buf) then
      terminal_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(terminal_buf, "bufhidden", "hide")
      vim.api.nvim_buf_call(terminal_buf, function()
        if not M.term_chan then
          M.term_chan = vim.fn.termopen(vim.o.shell)
        end
      end)
    end
    vim.cmd("vsplit")
    terminal_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(terminal_win, terminal_buf)
    vim.api.nvim_win_set_option(terminal_win, "number", false)
    local width = math.floor(vim.o.columns * 0.4)
    vim.api.nvim_win_set_config(terminal_win, { width = width })
    vim.cmd("startinsert")
  end
end

-- autoscroll
vim.api.nvim_create_autocmd("TextChanged", {
  pattern = "*",
  callback = function()
    if terminal_buf and terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
      local last_line = vim.api.nvim_buf_line_count(terminal_buf)
      vim.api.nvim_win_set_cursor(terminal_win, { last_line, 0 })
    end
  end,
})

-- reset REPL on exit
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function(ev)
    if ev.buf == terminal_buf then
      if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
        vim.api.nvim_win_close(terminal_win, true)
      end
      terminal_buf = nil
      terminal_win = nil
      M.term_chan = nil
    end
  end,
})

-- sending text to REPL
function M.send_to_terminal(text)
  if M.term_chan then
    vim.api.nvim_chan_send(M.term_chan, text .. "\n")
  else
    vim.notify("Aucun terminal actif", vim.log.levels.WARN)
  end
end

function M.terminal_is_bash_idle()
  local bufnr = vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end
  local lines = vim.api.nvim_buf_get_lines(bufnr, -10, -1, false)
  for _, line in ipairs(lines) do
    if line:match("%$%s*$") then
      return true
    end
  end
  return false
end

-- sending line
function M.send_line_to_terminal()
  local line = vim.api.nvim_get_current_line()
  M.send_to_terminal(line)
end

-- sending yanked text
function M.yank_and_send_to_terminal()
  vim.cmd('normal! "zy')
  local yanked_text = vim.fn.getreg("z")
  local lines = vim.split(yanked_text, "\n")
  for _, line in ipairs(lines) do
    if line:match("%S") then
      M.send_to_terminal(line)
    end
  end
end

-- sending visual selection
function M.send_selection_to_terminal()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "V" then
    M.yank_and_send_to_terminal()
    M.send_to_terminal("")
  else
    M.yank_and_send_to_terminal()
  end
end

-- keymaps
vim.keymap.set({ "n", "i", "t" }, "<c-\\>", M.ToggleVsplitTerminal, { noremap = true, silent = true })
vim.keymap.set("n", "<c-s>", M.send_line_to_terminal, { noremap = true, silent = true })
vim.keymap.set("v", "<c-s>", M.send_selection_to_terminal, { noremap = true, silent = true })

return M
