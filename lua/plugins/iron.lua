return{
  'Vigemus/iron.nvim',
  config = function()
    local iron = require("iron.core")
    iron.setup {
      config = {
       -- Whether a repl should be discarded or not
       scratch_repl = true,
       -- Your repl definitions come here
       repl_definition = {
        python = {
         command = {"bash"},
         format = require("iron.fts.common").bracketed_paste_python
        }
       },
       -- How the repl window will be displayed
       -- See below for more information
       repl_open_cmd = require('iron.view').split.vertical.botright(0.40),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
       visual_send = "<C-s>",
       send_line = "<C-s>",
       interrupt = "<C-c>",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
       italic = true
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }
  end
}
