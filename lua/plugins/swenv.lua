return {
  "AckslD/swenv.nvim" ,
  opts = {
    get_venvs = function(venvs_path)
      return require("swenv.api").get_venvs(venvs_path)
    end,
    venvs_path = vim.fn.expand("~/.venv"),
    post_set_venv = function()
      vim.cmd.LspRestart()
    end,
  },
}
