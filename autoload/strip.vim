" Author:  obcat <obcat@icloud.com>
" License: MIT License

vim9script


if !exists('g:strip_onwrite')
  g:strip_onwrite = 'confirm'
endif


const TRAIL_PATTERN = "[ \t\u3000]\\+$"


# :Strip
def strip#execute(range = [1, line('$')])
  const curpos = getpos('.')
  try
    execute printf(
      'keepjumps keeppatterns :%d,%d substitute /%s//e',
      range[0], range[1], TRAIL_PATTERN
    )
  finally
    setpos('.', curpos)
  endtry
enddef


# called on BufWritePre
def strip#onwrite()
  const config_varname = exists('b:strip_onwrite')
                        ? 'b:strip_onwrite'
                        : 'g:strip_onwrite'
  const config = eval(config_varname)
  if type(config) != v:t_string
    # FIXME: The message may be overwritten depending on 'shortmess'.
    strip#message#error(printf('[strip] Invalid argument: %s = %s', config_varname, strtrans(string(config))))
    return
  endif

  var doit: bool
  if config == 'always'
    doit = true
  elseif config == 'never'
    doit = false
  elseif config == 'confirm'
    if search(TRAIL_PATTERN, 'nw') >= 1
      const msg = 'Trailing whitespace detected. Strip?'
      const choices = join(['&Yes', '&No', '&Always', 'Ne&ver'], "\n")
      var choice: number
      try  #                             ┌ default: Yes
        choice = s:confirm(msg, choices, 1, 'Question')
      finally
        redraw  # avoid hit-enter prompt
      endtry
      doit = choice == 1 || choice == 3  # Yes or Always
      if choice == 3  # Always
        b:strip_onwrite = 'always'
      elseif choice == 4  # Never
        b:strip_onwrite = 'never'
      endif
    else
      doit = false
    endif
  else
    # FIXME: The message may be overwritten depending on 'shortmess'.
    strip#message#error(printf('[strip] Invalid argument: %s = %s', config_varname, strtrans(config)))
    return
  endif

  if doit
    Strip
  endif
enddef


if exists('g:strip_in_test')
  def s:confirm(msg: string, choices = '&OK', default = 1, type = 'Generic'): number
    return g:strip_confirm_choice
  enddef
else
  def s:confirm(msg: string, choices = '&OK', default = 1, type = 'Generic'): number
    return confirm(msg, choices, default, type)
  enddef
endif
