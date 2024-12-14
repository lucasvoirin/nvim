-- Variables globales pour le terminal flottant
local floating_buf = nil
local floating_win = nil

-- Fonction pour toggler le terminal flottant
function ToggleFloatingTerminal()
  if floating_win and vim.api.nvim_win_is_valid(floating_win) then
    -- Si la fenêtre flottante est déjà ouverte, la fermer
    vim.api.nvim_win_close(floating_win, true)
    floating_win = nil
  else
    if not floating_buf or not vim.api.nvim_buf_is_valid(floating_buf) then
      -- Créer un buffer flottant si aucun n'existe ou s'il a été supprimé
      floating_buf = vim.api.nvim_create_buf(false, true) -- Crée un buffer flottant non listé
      vim.api.nvim_buf_set_option(floating_buf, "bufhidden", "hide") -- Cache le buffer sans le supprimer
       -- Démarrer un terminal dans ce buffer
      vim.api.nvim_buf_call(floating_buf, function()
        vim.fn.termopen(vim.o.shell)
      end)
    end
     -- Ouvrir une fenêtre flottante avec le buffer existant
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
     -- Toujours mettre le terminal au-dessus des autres fenêtres
    vim.api.nvim_win_set_config(floating_win, { zindex = 1500 })
    vim.cmd("startinsert") -- Passe en mode insertion pour utiliser le terminal
  end
end

-- Fermer automatiquement le terminal flottant quand on tape "exit"
vim.api.nvim_create_autocmd("TermClose", {
  pattern = "*",
  callback = function(ev)
    if ev.buf == floating_buf then
      -- Fermer la fenêtre flottante et réinitialiser le buffer après "exit"
      if floating_win and vim.api.nvim_win_is_valid(floating_win) then
        vim.api.nvim_win_close(floating_win, true)
      end
      floating_buf = nil -- Réinitialiser pour créer un nouveau terminal à la prochaine ouverture
      floating_win = nil
    end
  end,
})

-- Raccourci pour toggler le terminal flottant
vim.keymap.set({"n", "i", "t"}, "<c-\\>", ToggleFloatingTerminal, { noremap = true, silent = true })
