local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

_G.python_env = {
  path = "/usr/bin/python3"
}

local function get_local_venv_python()
  local cwd = vim.fn.getcwd()
  local local_venv = cwd .. "/.venv"
  local path_unix = local_venv .. "/bin/python"
  local path_win = local_venv .. "/Scripts/python.exe"

  local uv = vim.loop
  if uv.fs_stat(path_unix) then
    return path_unix
  elseif uv.fs_stat(path_win) then
    return path_win
  else
    return nil
  end
end

local function scandir(directory)
  local uv = vim.loop
  local files = {}
  local fd = uv.fs_opendir(directory, nil, 100)
  if not fd then return files end
  while true do
    local entries = uv.fs_readdir(fd)
    if not entries then break end
    for _, entry in ipairs(entries) do
      if entry.type == "directory" then
        table.insert(files, entry.name)
      end
    end
  end
  uv.fs_closedir(fd)
  return files
end

local function select_venv()
  local home = os.getenv("HOME")
  local base_venv_dir = home .. "/.venv"
  local pyenv_dir = home .. "/.pyenv/versions"

  local venv_choices = {}
  local seen_paths = {}

  local function add_choice(label, path)
    if path and not seen_paths[path] and vim.loop.fs_stat(path) then
      table.insert(venv_choices, { label = label, path = path })
      seen_paths[path] = true
    end
  end

  -- .venv local
  add_choice(".venv (local)", get_local_venv_python())

  -- ~/.venv/*
  for _, name in ipairs(scandir(base_venv_dir)) do
    local p = base_venv_dir .. "/" .. name .. "/bin/python"
    add_choice(name .. " (~/.venv)", p)
  end

  -- pyenv versions
  for _, name in ipairs(scandir(pyenv_dir)) do
    local p = pyenv_dir .. "/" .. name .. "/bin/python"
    add_choice(name .. " (pyenv)", p)
  end

  if #venv_choices == 0 then
    vim.notify("Aucun environnement Python trouvé", vim.log.levels.WARN)
    return
  end

  vim.ui.select(venv_choices, {
    prompt = "Choisis un environnement Python :",
    format_item = function(item) return item.label end,
  }, function(choice)
    if choice then
      python_env.path = choice.path
      print("Environnement Python sélectionné :", choice.label)
      vim.cmd("LspRestart")
    else
      print("Aucun environnement sélectionné")
    end
  end)
end

vim.api.nvim_create_user_command("SelectVenv", select_venv, {})

lspconfig.pyright.setup({
  on_new_config = function(new_config)
    new_config.settings.python.pythonPath = python_env.path
  end,
  root_dir = util.root_pattern('.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt'),
})
