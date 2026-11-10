local mammouth_buf = nil
local mammouth_win = nil

local MAMMOUTH_CMD = "mammouth"

local function open_mammouth_win()
  mammouth_win = vim.api.nvim_open_win(mammouth_buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    col = math.floor(vim.o.columns * 0.1),
    row = math.floor(vim.o.lines * 0.1),
    style = "minimal",
    border = "rounded",
  })
  vim.cmd("startinsert")
end

local function create_mammouth_buf()
  mammouth_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[mammouth_buf].bufhidden = "hide"

  vim.api.nvim_buf_call(mammouth_buf, function()
    vim.fn.termopen(MAMMOUTH_CMD, { cwd = vim.fn.getcwd() })
  end)

  -- Pass-through : les mappings globaux du mode terminal (ex. <Esc><Esc>,
  -- <C-\>, <C-^> ...) capturaient les touches avant mammouth. On les recrée
  -- en buffer-local pour envoyer les touches brutes au process.
  -- On exclut <C-k> (toggle).
  for _, km in ipairs(vim.api.nvim_get_keymap("t")) do
    if km.lhs ~= "<C-k>" then
      vim.api.nvim_buf_set_keymap(mammouth_buf, "t", km.lhs, km.lhs,
        { noremap = true, silent = true })
    end
  end

  -- Toggle depuis le terminal : <C-k> ferme la fenêtre
  vim.keymap.set("t", "<C-S-M>", function()
    if mammouth_win and vim.api.nvim_win_is_valid(mammouth_win) then
      vim.api.nvim_win_close(mammouth_win, true)
      mammouth_win = nil
    end
  end, { buffer = mammouth_buf, noremap = true, silent = true })
end

function ToggleMammouth()
  if mammouth_win and vim.api.nvim_win_is_valid(mammouth_win) then
    vim.api.nvim_win_close(mammouth_win, true)
    mammouth_win = nil
    return
  end

  if not mammouth_buf or not vim.api.nvim_buf_is_valid(mammouth_buf) then
    create_mammouth_buf()
  end

  open_mammouth_win()
end

-- reset si le process qu
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function(ev)
    if ev.buf == mammouth_buf then
      if mammouth_win and vim.api.nvim_win_is_valid(mammouth_win) then
        vim.api.nvim_win_close(mammouth_win, true)
      end
      mammouth_buf = nil
      mammouth_win = nil
    end
  end,
})

-- Toggle : <leader>m en mode normal, <M-m> en mode terminal
vim.keymap.set("n", "<C-S-M>", ToggleMammouth, { noremap = true, silent = true })
