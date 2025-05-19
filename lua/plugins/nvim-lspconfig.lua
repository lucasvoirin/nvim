return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", config=true},
    "mason-org/mason-lspconfig.nvim",
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
