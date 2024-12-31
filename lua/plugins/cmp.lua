return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'kdheepak/cmp-latex-symbols',
  },
  opts = function ()
    local cmp = require('cmp')
    return {
      completion = {
	completeopt = 'menu,menuone,noinsert'
      },
      sources = {
	{ name = 'nvim_lsp'},
	{ name = 'buffer'},
	{ name = 'path'},
	{ name = 'latex_symbols' },
      },
      mapping = cmp.mapping.preset.insert {
	['<C-Space>'] = cmp.mapping.complete {},
	['<C-y>'] = cmp.mapping.confirm { select = true },
	['<C-n>'] = cmp.mapping.select_next_item(),
	['<C-p>'] = cmp.mapping.select_prev_item(),
	['<Right>'] = cmp.mapping(function(fallback)
	  if cmp.visible() then
	    cmp.abort()
	  else
	    fallback()
	  end
	end, { 'i', 's' }),
	['<C-b>'] = cmp.mapping.scroll_docs(-4),
	['<C-f>'] = cmp.mapping.scroll_docs(4),
      },
      formatting = {
	fields = { "abbr", "menu", "kind" },
	format = function(entry, item)
	  local icons = {
	    Text = "", Method = "", Function = "󰊕", Constructor = "", Field = "",
    	    Variable = "", Class = "", Interface = "", Module = "", Property = "",
	    Unit = "", Value = "", Enum = "", Keyword = "", Snippet = "", Color = "",
	    File = "", Reference = "", Folder = "", EnumMember = "", Constant = "π",
	    Struct = "", Event = "", Operator = "", TypeParameter = "",
	  }
	  item.kind = string.format("%s %s", icons[item.kind] or "", "")
	  item.menu = ({
	    nvim_lsp = "[LSP]",
	    buffer = "[Buffer]",
	    path = "[Path]",
	    latex_symbols = "[TeX]",
	  })[entry.source.name]
	  return item
	end,
      },
    }
  end,
}
