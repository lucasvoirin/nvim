return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    lazygit = { enabled = true },
    dashboard = { enabled = true,
      preset = {
	keys = {
	  { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
	  { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
	  { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
	  { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
	  { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
	  { icon = "󰉋 ", key = "p", desc = "Projects", action = ":lua require'telescope'.extensions.project.project{}"},
	  { icon = " ", key = "q", desc = "Quit", action = ":qa" },
	},
      },
      sections = {
	{ section = "keys", gap = 1, padding = 1 },
	{ pane = 2, icon = " ", title = "Recent Directories", section = "projects", indent = 2, padding = 1 },
	{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
	},
    },
    indent = { enabled = true },
    notifier = { enabled = true },
    scroll = { enabled = true },
    toggle = { enabled = true },
    zen = { enabled = true },
  },
}
