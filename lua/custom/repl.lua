local terminal_buf = nil
local terminal_win = nil
local term_chan = nil

function ToggleVsplitTerminal()
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    vim.api.nvim_win_close(terminal_win, true)
    terminal_win = nil
  else
    if not terminal_buf or not vim.api.nvim_buf_is_valid(terminal_buf) then
      terminal_buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_option(terminal_buf, "bufhidden", "hide")
      vim.api.nvim_buf_call(terminal_buf, function()
        if not term_chan then
          term_chan = vim.fn.termopen(vim.o.shell)
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
  buffer = terminal_buf,
  callback = function()
    if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
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
      term_chan = nil
    end
  end,
})

-- sending text to REPL
local function send_to_terminal(text)
  if term_chan then
    vim.api.nvim_chan_send(term_chan, text .. "\n")
  end
end

-- sending line
local function send_line_to_terminal()
  local line = vim.api.nvim_get_current_line()
  send_to_terminal(line)
end

-- sending yanked text 
local function yank_and_send_to_terminal()
  vim.cmd('normal! "zy')
  local yanked_text = vim.fn.getreg("z")
  local lines = vim.split(yanked_text, "\n")
  for _, line in ipairs(lines) do
    if line:match("%S") then
      send_to_terminal(line)
    end
  end
end

-- sending visual selection
local function send_selection_to_terminal()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "V" then
    yank_and_send_to_terminal()
    send_to_terminal("")
  else
    yank_and_send_to_terminal()
  end
end

-- keymaps
vim.keymap.set({"n", "i", "t"}, "<c-\\>", ToggleVsplitTerminal, { noremap = true, silent = true })
vim.keymap.set("n", "<c-s>", send_line_to_terminal, { noremap = true, silent = true })
vim.keymap.set("v", "<c-s>", send_selection_to_terminal, { noremap = true, silent = true })
