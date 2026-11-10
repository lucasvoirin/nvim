local M = {}

-- État interne du terminal (un seul terminal global)
local state = {
  buf = nil,
  win = nil,
  chan = nil,
}

-- Expose le channel pour compatibilité éventuelle avec l'existant
M.term_chan = nil

local function sync_term_chan()
  M.term_chan = state.chan
end

-- Crée le buffer terminal + ses autocmds locaux
local function create_terminal_buf()
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].bufhidden = "hide"

  vim.api.nvim_buf_call(state.buf, function()
    state.chan = vim.fn.termopen(vim.o.shell)
    sync_term_chan()
  end)
	
  -- Autoscroll restreint à CE buffer uniquement (fix du bug global)
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = state.buf,
    callback = function()
      if state.win and vim.api.nvim_win_is_valid(state.win) then
        local last_line = vim.api.nvim_buf_line_count(state.buf)
        pcall(vim.api.nvim_win_set_cursor, state.win, { last_line, 0 })
      end
    end,
  })

  -- Reset propre à la fermeture du terminal
  vim.api.nvim_create_autocmd("TermClose", {
    buffer = state.buf,
    once = true,
    callback = function()
      if state.win and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_close(state.win, true)
      end
      state.buf = nil
      state.win = nil
      state.chan = nil
      sync_term_chan()
    end,
  })

  -- Nettoyage si le buffer est supprimé autrement (:bd, etc.)
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = state.buf,
    once = true,
    callback = function()
      state.buf = nil
      state.win = nil
      state.chan = nil
      sync_term_chan()
    end,
  })
end

function M.ToggleVsplitTerminal()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    create_terminal_buf()
  end

  -- Force l'ouverture à droite quel que soit 'splitright'
  local original_splitright = vim.o.splitright
  vim.o.splitright = true
  vim.cmd("vsplit")
  vim.o.splitright = original_splitright

  state.win = vim.api.nvim_get_current_win()

  -- Protection contre les autocmds tiers (ex: snacks.nvim) qui crashent sur BufWinEnter
  local ok, err = pcall(vim.api.nvim_win_set_buf, state.win, state.buf)
  if not ok then
    vim.notify("Erreur lors de l'ouverture du terminal: " .. tostring(err), vim.log.levels.ERROR)
  end

  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].signcolumn = "no"

  local width = math.floor(vim.o.columns * 0.4)
  vim.cmd("vertical resize " .. width)
  vim.cmd("startinsert")
end

function M.send_to_terminal(text)
  if not state.chan then
    vim.notify("Aucun terminal actif", vim.log.levels.WARN)
    return
  end
  local start_paste = "\27[200~"
  local end_paste = "\27[201~"

  -- Si la dernière ligne du texte est indentée (bloc for/def/if/while/etc.),
  -- on ajoute une ligne vide pour qu'IPython clôture le bloc.
  local lines = vim.split(text, "\n")
  local last_line = lines[#lines]
  local needs_blank_line = last_line:match("^%s+%S")

  local payload = text
  if needs_blank_line then
    payload = text .. "\n"
  end

  vim.api.nvim_chan_send(state.chan, start_paste .. payload .. end_paste .. "\r")
end

--- Vérifie si le terminal semble "idle" (prompt bash visible)
function M.terminal_is_bash_idle()
  if not state.buf or not vim.api.nvim_buf_is_loaded(state.buf) then
    return false
  end
  local line_count = vim.api.nvim_buf_line_count(state.buf)
  local from = math.max(0, line_count - 10)
  local lines = vim.api.nvim_buf_get_lines(state.buf, from, line_count, false)
  for _, line in ipairs(lines) do
    if line:match("%$%s*$") then
      return true
    end
  end
  return false
end

--- Envoie la ligne courante
function M.send_line_to_terminal()
  local line = vim.api.nvim_get_current_line()
  M.send_to_terminal(line)
end

function M.yank_and_send_to_terminal()
  vim.cmd('normal! "zy')
  local yanked_text = vim.fn.getreg("z")
  local text = yanked_text:gsub("\n$", "")
  M.send_to_terminal(text)
end

--- Envoie la sélection visuelle (ligne ou caractère)
function M.send_selection_to_terminal()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "V" then
    M.yank_and_send_to_terminal()
  else
    M.yank_and_send_to_terminal()
  end
end

--- Envoie le paragraphe courant (bloc délimité par des lignes vides)
function M.send_paragraph_to_terminal()
  local cur_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  local start_line = cur_line
  while start_line > 1 do
    local text = vim.fn.getline(start_line - 1)
    if text:match("^%s*$") then
      break
    end
    start_line = start_line - 1
  end

  local end_line = cur_line
  while end_line < total_lines do
    local text = vim.fn.getline(end_line + 1)
    if text:match("^%s*$") then
      break
    end
    end_line = end_line + 1
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local block = table.concat(lines, "\n")
  M.send_to_terminal(block)
end

--- Getters utiles
function M.get_terminal_win()
  return state.win
end

function M.get_terminal_buf()
  return state.buf
end

function M.get_terminal_chan()
  return state.chan
end

-- Commande utilisateur pour envoyer du texte arbitraire
vim.api.nvim_create_user_command("ReplSend", function(opts)
  M.send_to_terminal(opts.args)
end, { nargs = "+" })

-- Keymaps
vim.keymap.set({ "n", "i", "t" }, "<c-\\>", M.ToggleVsplitTerminal, { noremap = true, silent = true })
vim.keymap.set("n", "<c-s>", M.send_line_to_terminal, { noremap = true, silent = true })
vim.keymap.set("v", "<c-s>", M.send_selection_to_terminal, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sp", M.send_paragraph_to_terminal, { noremap = true, silent = true })

return M
