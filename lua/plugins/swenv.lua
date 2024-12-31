return {
  "AckslD/swenv.nvim" ,
  config = function()
    require("swenv").setup({
      get_venvs = function(venvs_path)
        return require("swenv.api").get_venvs(venvs_path)
      end,
      venvs_path = vim.fn.expand("~/.venv"),
      -- Something to do after setting an environment
      post_set_venv = function()
        vim.cmd.LspRestart()
      end,
    })
  end,
}
