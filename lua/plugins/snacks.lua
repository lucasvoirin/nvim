return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = { enabled = true },
    dashboard = { enabled = true,
      sections = {
	{ icon = " ", title = "Recent Directories", section = "projects", indent = 2, padding = 1 },
	{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
	},
    },
    indent = { enabled = true },
    notifier = { enabled = true },
    scroll = { enabled = true },
    toggle = { enabled = true },
    zen = { enabled = true },
  },
}
