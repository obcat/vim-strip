" Author:  obcat <obcat@icloud.com>
" License: MIT License

vim9script


if exists('g:loaded_strip')
  finish
endif
g:loaded_strip = true


command! -bar -range=% Strip strip#execute([<line1>, <line2>])


augroup strip-onwrite
  autocmd!
  autocmd BufWritePre * strip#onwrite()
augroup END
