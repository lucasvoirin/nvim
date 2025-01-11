return {
  'nvim-lualine/lualine.nvim',
  opts = {
    sections = {
      lualine_c = {
	{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 }},
	{ "filename",path = 0, padding = { left = 0, right = 1 } , show_modified_status = true },
      },
      lualine_x = {
	{
	  "swenv",
	  cond = function() return vim.bo.filetype == "python" end,
	  icon = "[]",
	  color = { fg = "#8fb55e" }
	}
      },
      lualine_y = {},
      lualine_z = {
	{ "location", separator = " /", padding = { left = 0, right = 0 } }, "vim.fn.line('$')"
      },
    },
  },
}
