return {
  'stevearc/oil.nvim',
  opts = {
    float = {
      padding = 8,
      max_width = 0,
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 0,
      }
    },
		-- c'est pour que oil ne puisse pas ouvrir un nouveau fichier dans un repl
    keymaps = {
      ["<CR>"] = function()
        local term = require("custom.repl")
				local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))

        if prev_win == term.get_terminal_win() then
          vim.notify("Non disponible depuis le terminal", vim.log.levels.WARN)
          return
        end

        require("oil").select()
      end,
    },
  },
}
