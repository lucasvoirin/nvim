# nvim data science ide config

This is my Neovim config! It is built from scratch but heavily inspired by [nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim),
[quarto-nvim-kickstarter](https://github.com/jmbuhr/quarto-nvim-kickstarter) and [LazyVim](http://www.lazyvim.org/).

I'm using Neovim as an IDE for data science (with R, Python and Julia) and writing (with LaTeX and Quarto).

## Structure

```plaintext
~/.config/nvim
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   └── options.lua
│   ├── plugins
│   │    └── ...
│   └── custom
│        └── floating-terminal.lua
├── init.lua
└── README.md
```

### Config

Configuration files are located in the `./lua/config/` directory. They are loaded from `./init.lua`.

Here is a list of configuration files:

| File         | Decription          |
|--------------|---------------------|
|`options.lua` | set (neo)vim option |
|`lazy.lua`    | load plugins        |
|`mappings.lua`| set keymaps         |
|`autocmds.lua`| set autocommands    |

### Plugins

Plugins are managed by [lazy](https://github.com/folke/lazy.nvim). Configuration lua files are
located in the `./lua/plugins/` directory and automatically loaded from `./lua/config/lazy.lua`.

Here is a list of main plugins:

| Plugin                                                                        | Description       |
|-------------------------------------------------------------------------------|-------------------|
| [lazy](https://github.com/folke/lazy.nvim)                                    | plugin manager    |
| [oil](https://github.com/stevearc/oil.nvim)                                   | filesystem editor |
| [which-key](https://github.com/folke/which-key.nvim)                          | keymaps memo      |
| [telescope](https://github.com/nvim-telescope/telescope.nvim)                 | search engine     |
| [lualine](https://github.com/nvim-lualine/lualine.nvim)                       | status bar        |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)           | set of icons      |
| [tokyonight](https://github.com/folke/tokyonight.nvim)                        | color theme       |
| [noice](https://github.com/folke/noice.nvim)                                  | improved ui       |
| [snacks](https://github.com/folke/snacks.nvim)                                | misc utilities    |
| [telescope-project](https://github.com/nvim-telescope/telescope-project.nvim) | project manager   |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                               | completion engine |

### Custom

`./lua/custom/` contains custom lua scripts adding features to Neovim. Scripts in this directory are loaded from `./init.lua`.

Here is a list of custom features:

| File                    | Description                                      |
|-------------------------|--------------------------------------------------|
| `floating-terminal.lua` | Add a terminal popup accessible anywhere anytime |

## Usage

### Features

This section is used as a roadmap.

- [x] Navigation and edition of file system with Oil
- [x] Opening Floating Terminal anywhere anytime
- [x] Manage projects
- [x] autocomplete witn nvim-cmp
- [x] lsp
- [x] R, Python and Julia REPL
- [x] git integration with snacks and gitsigns
- [x] zotero integration with telescope

### Memo

| Keymap     | Action                   |
|------------|--------------------------|
|`<space>o`  | Open Oil                 |
|`<space>g`  | Open LazyGit             |
|`<space>fh` | Find Help                |
|`<space>fp` | Find Project             |
|`<space>fr` | Find Zotero Reference    |
|`<c-\>`     | Toggle Floating Terminal |
|`<space>tb` | Toggle Light Background  |
|`<space>tl` | Toggle Relative Number   |
|`<space>td` | Toggle LSP Diagnostics   |

