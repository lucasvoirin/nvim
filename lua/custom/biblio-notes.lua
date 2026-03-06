-- Manage citation formats for different filetypes
local cite_formats = {
  tex = {
    start_str = [[\cite{]],
    end_str = "}",
    separator_str = ", ",
  },
  markdown = {
    ref_prefix = "@",
    separator_str = "; ",
  },
  rmd = {
    ref_prefix = "@",
    separator_str = "; ",
  },
  plain = {
    separator_str = ", ",
  },
  org = {
    start_str = "[cite:",
    end_str = "]",
    ref_prefix = "@",
    separator_str = ";",
  },
  norg = {
    start_str = "{= ",
    end_str = "}",
    separator_str = "; ",
  },
  typst = {
    ref_prefix = "@",
    separator_str = " ",
  },
}

local cite_formats_fallback = "plain"
local always_use_plain = false

-- Get citation format for current filetype
local function get_cite_format()
  local filetype = vim.bo.filetype
  local fallback = { separator_str = ", " }

  if always_use_plain then
    return cite_formats.plain or fallback
  else
    return cite_formats[filetype] or cite_formats[cite_formats_fallback]
  end
end

-- Get citation key under cursor
local function get_ref_under_cursor()
  local cite_format = get_cite_format()
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Check LaTeX style citations \cite{key1, key2}
  for start_pos, command, refs in line:gmatch("()\\(%a+)%s*{([^}]+)}") do
    local block_start = start_pos
    local block_end = start_pos + #command + 1 + #refs + 2

    if cursor_col >= block_start and cursor_col <= block_end then
      local refs_start = block_start + #command + 2
      local i = 0
      for ref in refs:gmatch("([^,%s]+)") do
        local s, e = refs:find(ref, i + 1, true)
        i = e or i
        if s and e then
          local abs_start = refs_start + s - 1
          local abs_end = refs_start + e - 1
          if cursor_col >= abs_start and cursor_col <= abs_end then
            if cite_format.ref_prefix then
              ref = ref:gsub("^" .. vim.pesc(cite_format.ref_prefix), "")
            end
            return ref
          end
        end
      end

      -- If cursor inside block but not on a key, return first key
      local first_ref = refs:match("([^,%s]+)")
      if first_ref then
        if cite_format.ref_prefix then
          first_ref = first_ref:gsub("^" .. vim.pesc(cite_format.ref_prefix), "")
        end
        return first_ref
      end
    end
  end

  -- Check Markdown / Pandoc style citations [@key1; @key2]
  for start_pos, refs in line:gmatch("()%[@([^%]]+)%]") do
    local block_end = start_pos + #refs + 3
    if cursor_col >= start_pos and cursor_col <= block_end then
      for ref in refs:gmatch("@([^,%s;]+)") do
        local s, e = refs:find("@" .. ref, 1, true)
        if s and e then
          local abs_start = start_pos + s
          local abs_end = start_pos + e
          if cursor_col >= abs_start and cursor_col <= abs_end then
            return ref
          end
        end
      end
      -- If cursor inside block but not on a key, return first
      local first_ref = refs:match("@([^,%s;]+)")
      if first_ref then
        return first_ref
      end
    end
  end

  -- No reference found
  return nil
end

-- Open a note in Obsidian for a given reference
local function open_obsidian_note(vault, note)
  local uri = "obsidian://open?vault=" .. vault .. "&file=Papers/@" .. note
  local open_cmd
  if vim.fn.has("macunix") == 1 then
    open_cmd = "open"
  elseif vim.fn.has("win32") == 1 then
    open_cmd = "start"
  else
    open_cmd = "xdg-open"
  end
  vim.fn.jobstart({ open_cmd, uri }, { detach = true })
end

-- Main function to open reference under cursor
local function open_ref_obsidian()
  local note = get_ref_under_cursor()
  if not note or note == "" then
    vim.notify("No reference detected under cursor.", vim.log.levels.WARN)
    return
  end
  local vault = "Doctorat"
  open_obsidian_note(vault, note)
end

-- Keymaps
vim.keymap.set("n", "gbbt", function()
  local ref = get_ref_under_cursor()
  if ref then
    vim.notify("Reference: " .. ref, vim.log.levels.INFO)
  else
    vim.notify("No reference detected under cursor.", vim.log.levels.WARN)
  end
end, { desc = "Show reference under cursor" })

vim.keymap.set("n", "go", open_ref_obsidian, { desc = "Open reference in Obsidian" })

-- Optional user command
vim.api.nvim_create_user_command("OpenRef", open_ref_obsidian, {
  desc = "Open the reference under cursor in Obsidian",
})
