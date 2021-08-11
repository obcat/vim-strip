" Author:  obcat <obcat@icloud.com>
" License: MIT License

vim9script


def strip#message#error(msg: string)
  s:echomsg(msg, 'ErrorMsg')
enddef


def s:echomsg(msg: string, hl = 'None')
  execute 'echohl' hl
  try
    for line in split(msg, "\n")
      echomsg line
    endfor
  finally
    echohl None
  endtry
enddef
