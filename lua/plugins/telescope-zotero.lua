return {
  'jmbuhr/telescope-zotero.nvim',
  dependencies = {'kkharji/sqlite.lua'},
  config = function()
    require'zotero'.setup{
      zotero_db_path = '~/.Zotero/zotero.sqlite',
      better_bibtex_db_path = '~/.Zotero/better-bibtex.sqlite',
      zotero_storage_path = '~/.Zotero/storage', }
  end,
}
