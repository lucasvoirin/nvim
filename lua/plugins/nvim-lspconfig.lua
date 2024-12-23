return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason.nvim", config = true},
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason-lspconfig").setup({
      handlers = {
	function(server_name)
	  require("lspconfig")[server_name].setup({
	    capabilities = require("cmp_nvim_lsp").default_capabilities(),
	  })
	end,
      },
    })
  end,
}
