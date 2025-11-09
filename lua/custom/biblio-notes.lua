local cite_formats = {
    tex = {
      start_str = [[\cite{]],
      end_str = "}",
      separator_str = ", ",
    },
    markdown = {
      ref_prefix = "@",
      separator_str = "; "
    },
    rmd = {
      ref_prefix = "@",
      separator_str = "; "
    },
    plain = {
      separator_str = ", "
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



---Get the cite_format for the current filetype
---@return table #cite_format to be used for the filetype. If table, then first is for inserting, second for parsing
local function get_cite_format()
  local filetype = vim.bo.filetype

  -- local cite_formats = self.cite_formats
  -- local cite_formats_fallback = self.cite_formats_fallback

  local fallback = {
    separator_str = ", "
  }

  if always_use_plain then
    local cite_format = cite_formats.plain or fallback
    return cite_format
  else
    local cite_format = cite_formats[filetype] or cite_formats[cite_formats_fallback]
    return cite_format
  end
end





---Tries to identify the ref under cursor
---@return string|nil #Nil if nothing is found, otherwise is the identified ref
local function get_ref_under_cursor()
  local cite_format = get_cite_format()
  local current_line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Lua index starts at 1

  -- Chercher tous les blocs \command{ref1,ref2}
  for start_pos, command, refs in current_line:gmatch("()\\(%a+)%s*{([^}]+)}") do
    local cite_block_end = start_pos + #command + 1 + #refs + 2 -- \ + command + {refs}

    if cursor_col >= start_pos and cursor_col <= cite_block_end then
      local all_refs = {}
      for ref in refs:gmatch("([^,%s]+)") do
        table.insert(all_refs, ref)
      end

      if #all_refs > 0 then
        if #all_refs == 1 then
          return all_refs[1]
        else
          print("Plusieurs refs trouvées, ouverture de la première: " .. all_refs[1])
          return all_refs[1]
        end
      end
    end
  end

  -- Fallback générique
  local line_until_cursor = current_line:sub(1, cursor_col)
  local word_start_col = line_until_cursor:find("[^%s,;]*$") or 1
  local line_after_cursor = current_line:sub(cursor_col)
  local word_end_col = cursor_col + (line_after_cursor:find("[%s,;%]]") or #line_after_cursor) - 1
  local ref = current_line:sub(word_start_col, word_end_col)

  -- nettoyage du prefix
  local ref_prefix = cite_format.ref_prefix
  if ref_prefix then
    local escaped_ref_prefix = ref_prefix:gsub("%W", "%%%0")
    local _, ref_start = string.find(ref, escaped_ref_prefix)
    if ref_start then
      ref = string.sub(ref, ref_start + 1)
    end
  end

  ref = ref:gsub("^[%p%s]*(.-)[%p%s]*$", "%1")

  return ref
end

local function open_obsidian_note(vault,note)
  local uri = "obsidian://open?vault=" .. vault .. "&file=Papers/@" .. note
  print(uri)
  vim.fn.jobstart({"xdg-open", uri}, {detach = true})
end

local function open_ref_obsidian()
  local note = get_ref_under_cursor()
  local vault = "Doctorat"
  open_obsidian_note(vault,note)
end

vim.keymap.set("n", "gbbt", function()
  local ref = get_ref_under_cursor()
  if ref then
    print("Ref: " .. ref)
  else
    print("Aucune référence trouvée")
  end
end, { desc = "Afficher la référence sous le curseur" })


vim.keymap.set("n", "go", open_ref_obsidian, { desc = "Open ref in obsidian" })

