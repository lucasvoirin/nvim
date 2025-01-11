return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      component_separators = { left = "｜", right = "｜" },
      section_separators = { left = " ", right = " " },
      disabled_filetypes = {
      statusline = {"snacks_dashboard"},
    },
    },
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
        {
          function() 
            local line = vim.fn.line('.')
            local col = vim.fn.col('.')
            local total_lines = vim.fn.line('$')
            return string.format("%d:%d / %d", line, col, total_lines)
          end,
          separator = " / ",
          cond = function() return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "snacks_dashboard" end
        }
      },
    },
    inactive_sections = {
      lualine_c = {
	{
	  'filename',
	  path = 3
	}
      },
      lualine_x = {
	{
	  'location',
	  cond = function() return vim.bo.buftype ~= "terminal" and vim.bo.filetype ~= "snacks_dashboard" end
        }
      },
    },
  },
}
