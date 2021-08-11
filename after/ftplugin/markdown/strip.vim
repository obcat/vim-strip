" Author:  obcat <obcat@icloud.com>
" License: MIT License

vim9script


if exists('b:did_strip_markdown_ftplugin') || get(g:, 'strip_no_ftplugin', false)
  finish
endif


b:strip_onwrite = 'never'


b:did_strip_markdown_ftplugin = true
if exists('b:undo_ftplugin')
  b:undo_ftplugin ..= ' | '
else
  b:undo_ftplugin = ''
endif
b:undo_ftplugin ..= 'unlet! b:strip_onwrite b:did_strip_markdown_ftplugin'
