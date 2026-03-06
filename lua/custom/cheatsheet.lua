-- ~/.config/nvim/lua/custom/cheatsheet.lua
local M = {}

local cheatsheet_lines = {
  "Global:",
  "  :h[elp] keyword - open help for keyword",
  "  :sav[eas] file - save file as",
  "  :clo[se] - close current pane",
  "  :ter[minal] - open a terminal window",
  "  K - open man page for word under the cursor",

  "Cursor movement:",
	"  ) - move to the next sentence",
	"  ( - move to the previous sentence",
  "  h - move cursor left",
  "  j - move cursor down",
  "  k - move cursor up",
  "  l - move cursor right",
  "  gj - move cursor down (multi-line text)",
  "  gk - move cursor up (multi-line text)",
  "  H - move to top of screen",
  "  M - move to middle of screen",
  "  L - move to bottom of screen",
  "  w - jump forwards to the start of a word",
  "  W - jump forwards to the start of a word (words can contain punctuation)",
  "  e - jump forwards to the end of a word",
  "  E - jump forwards to the end of a word (words can contain punctuation)",
  "  b - jump backwards to the start of a word",
  "  B - jump backwards to the start of a word (words can contain punctuation)",
  "  ge - jump backwards to the end of a word",
  "  gE - jump backwards to the end of a word (words can contain punctuation)",
  "  % - move cursor to matching character (default supported pairs: '()', '{}', '[]')",
  "  0 - jump to the start of the line",
  "  ^ - jump to the first non-blank character of the line",
  "  $ - jump to the end of the line",
  "  g_ - jump to the last non-blank character of the line",
  "  gg - go to the first line of the document",
  "  G - go to the last line of the document",
  "  5gg or 5G - go to line 5",
  "  gd - move to local declaration",
  "  gD - move to global declaration",
  "  fx - jump to next occurrence of character x",
  "  tx - jump to before next occurrence of character x",
  "  Fx - jump to the previous occurrence of character x",
  "  Tx - jump to after previous occurrence of character x",
  "  ; - repeat previous f, t, F or T movement",
  "  , - repeat previous f, t, F or T movement, backwards",
  "  } - jump to next paragraph (or function/block)",
  "  { - jump to previous paragraph (or function/block)",
  "  zz - center cursor on screen",
  "  zt - position cursor on top of the screen",
  "  zb - position cursor on bottom of the screen",
  "  Ctrl + e - move screen down one line (without moving cursor)",
  "  Ctrl + y - move screen up one line (without moving cursor)",
  "  Ctrl + b - move screen up one page (cursor to last line)",
  "  Ctrl + f - move screen down one page (cursor to first line)",
  "  Ctrl + d - move cursor and screen down 1/2 page",
  "  Ctrl + u - move cursor and screen up 1/2 page",

  "Insert mode - inserting/appending text:",
  "  i - insert before the cursor",
  "  I - insert at the beginning of the line",
  "  a - insert (append) after the cursor",
  "  A - insert (append) at the end of the line",
  "  o - append (open) a new line below the current line",
  "  O - append (open) a new line above the current line",
  "  ea - insert (append) at the end of the word",
  "  Ctrl + h - delete the character before the cursor during insert mode",
  "  Ctrl + w - delete word before the cursor during insert mode",
  "  Ctrl + j - add a line break at the cursor position during insert mode",
  "  Ctrl + t - indent (move right) line one shiftwidth during insert mode",
  "  Ctrl + d - de-indent (move left) line one shiftwidth during insert mode",
  "  Ctrl + n - insert (auto-complete) next match before the cursor during insert mode",
  "  Ctrl + p - insert (auto-complete) previous match before the cursor during insert mode",
  "  Ctrl + rx - insert the contents of register x",
  "  Ctrl + ox - temporarily enter normal mode to issue one normal-mode command x",
  "  Esc or Ctrl + c - exit insert mode",

  "Editing:",
  "  r - replace a single character",
  "  R - replace more than one character, until ESC is pressed",
  "  J - join line below to the current one with one space in between",
  "  gJ - join line below to the current one without space in between",
  "  gwip - reflow paragraph",
  "  g~ - switch case up to motion",
  "  gu - change to lowercase up to motion",
  "  gU - change to uppercase up to motion",
  "  cc - change (replace) entire line",
  "  c$ or C - change (replace) to the end of the line",
  "  ciw - change (replace) entire word",
  "  cw or ce - change (replace) to the end of the word",
  "  s - delete character and substitute text (same as cl)",
  "  S - delete line and substitute text (same as cc)",
  "  xp - transpose two letters (delete and paste)",
  "  u - undo",
  "  U - restore (undo) last changed line",
  "  Ctrl + r - redo",
  "  . - repeat last command",

  "Marking text (visual mode):",
  "  v - start visual mode, mark lines, then do a command (like y-yank)",
  "  V - start linewise visual mode",
  "  o - move to other end of marked area",
  "  Ctrl + v - start visual block mode",
  "  O - move to other corner of block",
  "  aw - mark a word",
  "  ab - a block with ()",
  "  aB - a block with {}",
  "  at - a block with <> tags",
  "  ib - inner block with ()",
  "  iB - inner block with {}",
  "  it - inner block with <> tags",
  "  Esc or Ctrl + c - exit visual mode",

  "Visual commands:",
  "  > - shift text right",
  "  < - shift text left",
  "  y - yank (copy) marked text",
  "  d - delete marked text",
  "  ~ - switch case",
  "  u - change marked text to lowercase",
  "  U - change marked text to uppercase",

  "Registers:",
  "  :reg[isters] - show registers content",
  "  \"xy - yank into register x",
  "  \"xp - paste contents of register x",
  "  \"+y - yank into the system clipboard register",
  "  \"+p - paste from the system clipboard register",

  "Marks and positions:",
  "  :marks - list of marks",
  "  ma - set current position for mark A",
  "  `a - jump to position of mark A",
  "  y`a - yank text to position of mark A",
  "  `0 - go to the position where Vim was previously exited",
  "  `\" - go to the position when last editing this file",
  "  `. - go to the position of the last change in this file",
  "  `` - go to the position before the last jump",
  "  :ju[mps] - list of jumps",
  "  Ctrl + i - go to newer position in jump list",
  "  Ctrl + o - go to older position in jump list",
  "  :changes - list of changes",
  "  g, - go to newer position in change list",
  "  g; - go to older position in change list",
  "  Ctrl + ] - jump to the tag under cursor",

  "Macros:",
  "  qa - record macro a",
  "  q - stop recording macro",
  "  @a - run macro a",
  "  @@ - rerun last run macro",

  "Cut and paste:",
  "  yy - yank (copy) a line",
  "  2yy - yank (copy) 2 lines",
  "  yw - yank (copy) characters from cursor to next word",
  "  yiw - yank (copy) word under cursor",
  "  yaw - yank (copy) word under cursor including space",
  "  y$ or Y - yank (copy) to end of line",
  "  p - put (paste) after cursor",
  "  P - put (paste) before cursor",
  "  gp - put after cursor and leave cursor after new text",
  "  gP - put before cursor and leave cursor after new text",
  "  dd - delete (cut) a line",
  "  2dd - delete (cut) 2 lines",
  "  dw - delete (cut) characters from cursor to next word",
  "  diw - delete (cut) word under cursor",
  "  daw - delete (cut) word under cursor including space",
  "  :3,5d - delete lines 3 to 5",

  "Indent text:",
  "  >> - indent (move right) line one shiftwidth",
  "  << - de-indent (move left) line one shiftwidth",
  "  >% - indent block with () or {}",
  "  <% - de-indent block with () or {}",
  "  >ib - indent inner block with ()",
  "  >at - indent block with <> tags",
  "  3== - re-indent 3 lines",
  "  =% - re-indent block with () or {}",
  "  =iB - re-indent inner block with {}",
  "  gg=G - re-indent entire buffer",
  "  ]p - paste and adjust indent to current line",

  "Exiting:",
  "  :w - write (save) file, but don't exit",
  "  :w !sudo tee % - write file using sudo",
  "  :wq or :x or ZZ - write (save) and quit",
  "  :q - quit (fails if unsaved changes)",
  "  :q! or ZQ - quit and discard changes",
  "  :wqa - write and quit all tabs",

  "Search and replace:",
  "  /pattern - search for pattern",
  "  ?pattern - search backward for pattern",
  "  \\vpattern - very magic pattern",
  "  n - repeat search same direction",
  "  N - repeat search opposite direction",
  "  :%s/old/new/g - replace all",
  "  :%s/old/new/gc - replace all with confirmations",
  "  :noh[lsearch] - remove highlighting of search matches",

  "Tabs:",
  "  :tabnew or :tabnew {file} - open file in new tab",
  "  Ctrl + wT - move current split into its own tab",
  "  gt or :tabn[ext] - next tab",
  "  gT or :tabp[revious] - previous tab",
  "  #gt - go to tab number #",
  "  :tabm[ove] # - move current tab to # position",
  "  :tabc[lose] - close current tab",
  "  :tabo[nly] - close all other tabs",
  "  :tabdo command - run command on all tabs",

  "Working with multiple files:",
  "  :e[dit] file - edit file in new buffer",
  "  :bn[ext] - next buffer",
  "  :bp[revious] - previous buffer",
  "  :bd[elete] - delete buffer",
  "  :b[uffer]# - go to buffer by index",
  "  :b[uffer] file - go to buffer by file",
  "  :ls or :buffers - list open buffers",
  "  :sp[lit] file - split window horizontally",
  "  :vs[plit] file - split window vertically",
  "  :vert[ical] ba[ll] - edit all buffers vertical",
  "  :tab ba[ll] - edit all buffers as tabs",
  "  Ctrl + ws - split window",
  "  Ctrl + wv - split window vertically",
  "  Ctrl + ww - switch windows",
  "  Ctrl + wq - quit a window",
  "  Ctrl + wx - exchange window with next",
  "  Ctrl + w= - equalize windows",
  "  Ctrl + wh - move cursor left",
  "  Ctrl + wl - move cursor right",
  "  Ctrl + wj - move cursor down",
  "  Ctrl + wk - move cursor up",
  "  Ctrl + wH - full height left",
  "  Ctrl + wL - full height right",
  "  Ctrl + wJ - full width bottom",
  "  Ctrl + wK - full width top",

  "Diff:",
  "  zf - define fold",
  "  zd - delete fold",
  "  za - toggle fold",
  "  zo - open fold",
  "  zc - close fold",
  "  zr - reduce folds",
  "  zm - fold more",
  "  zi - toggle folding",
  "  ]c - next change",
  "  [c - previous change",
  "  do or :diffg[et] - get diff",
  "  dp or :diffpu[t] - put diff",
  "  :diffthis - diff current window",
  "  :dif[fupdate] - update differences",
  "  :diffo[ff] - turn off diff mode",
}

local title_hl = "Title"       -- follow colorscheme
local cmd_hl   = "Visual"      -- use Visual for highlight background

local win_id = nil
local buf_id = nil

function M.toggle_cheatsheet(num_cols)
  num_cols = num_cols or 1

  if win_id and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
    win_id = nil
    buf_id = nil
    return
  end

  buf_id = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  win_id = vim.api.nvim_open_win(buf_id, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  vim.api.nvim_buf_set_option(buf_id, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf_id, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf_id, "swapfile", false)
  vim.api.nvim_buf_set_option(buf_id, "modifiable", true)
  vim.api.nvim_win_set_option(win_id, "wrap", false)
  vim.api.nvim_win_set_option(win_id, "cursorline", false)

  -- Compute max width per column
  local col_width = {}
  local lines_per_col = math.ceil(#cheatsheet_lines / num_cols)
  for c = 1, num_cols do
    local max_w = 0
    for i = (c-1)*lines_per_col+1, math.min(c*lines_per_col, #cheatsheet_lines) do
      local l = cheatsheet_lines[i]
      if #l > max_w then max_w = #l end
    end
    col_width[c] = max_w
  end

  -- Build multi-column lines
  local output_lines = {}
  for i = 1, lines_per_col do
    local line = ""
    for c = 1, num_cols do
      local idx = (c-1)*lines_per_col + i
      if idx <= #cheatsheet_lines then
        local text = cheatsheet_lines[idx]
        line = line .. text .. string.rep(" ", col_width[c]+2 - #text)
      end
    end
    table.insert(output_lines, line)
  end

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, output_lines)
  vim.api.nvim_buf_set_option(buf_id, "modifiable", false)

-- Highlight titles and commands
for i, line in ipairs(output_lines) do
  local start_col = 0
  for c = 1, num_cols do
    local idx = (c-1)*lines_per_col + i
    if idx <= #cheatsheet_lines then
      local text = cheatsheet_lines[idx]

      -- Titles highlight entire line
      if text:match(".+:$") then
        vim.api.nvim_buf_add_highlight(buf_id, -1, title_hl, i-1, start_col, start_col + #text)
      else
        -- Highlight command: everything up to the first space before " -"
        local cmd = text:match("^%s*(.-)%s%-")
        if not cmd then
          -- fallback if no " -", highlight everything before first space
          cmd = text:match("^%s*(%S+)")
        end
        if cmd then
          local s, e = text:find(cmd, 1, true)
          if s and e then
            vim.api.nvim_buf_add_highlight(buf_id, -1, cmd_hl, i-1, start_col + s - 1, start_col + e)
          end
        end
      end

      start_col = start_col + col_width[c] + 2
    end
  end
end

  -- Keymaps to close
  vim.api.nvim_buf_set_keymap(buf_id, "n", "<Esc>", "<cmd>lua require'custom.cheatsheet'.toggle_cheatsheet()<CR>", { noremap=true, silent=true })
  vim.api.nvim_buf_set_keymap(buf_id, "n", "q", "<cmd>lua require'custom.cheatsheet'.toggle_cheatsheet()<CR>", { noremap=true, silent=true })
end

-- Map <leader>h to toggle cheatsheet
vim.keymap.set("n", "<leader>h", function() M.toggle_cheatsheet(1) end, { desc="Toggle Vim cheatsheet" })

return M
