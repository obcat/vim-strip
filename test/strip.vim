let s:suite = themis#suite('strip')


function s:suite.before_each()
  % bwipeout!
endfunction

function s:suite.after()
  call self.before_each()
endfunction


function s:suite.whitespace_chars()
  call setline(1, ['some '])
  Strip
  call g:assert.equals(getline(1, '$'), ['some'], '#1')

  bwipeout!
  call setline(1, ["some\t"])
  Strip
  call g:assert.equals(getline(1, '$'), ["some"], '#2')

  bwipeout!
  call setline(1, ["some\u3000"])
  Strip
  call g:assert.equals(getline(1, '$'), ["some"], '#3')
endfunction


function s:suite.trail_only()
  call setline(1, [' some '])
  Strip
  call g:assert.equals(getline(1, '$'), [' some'], '#1')
endfunction


function s:suite.multiple_trail()
  call setline(1, ["some \t\u3000"])
  Strip
  call g:assert.equals(getline(1, '$'), ['some'], '#1')
endfunction


function s:suite.default_range()
  call setline(1, [
        \   'foo ',
        \   'bar ',
        \   'baz ',
        \   'qux ',
        \ ])
  Strip
  call g:assert.equals(getline(1, '$'), [
        \   'foo',
        \   'bar',
        \   'baz',
        \   'qux',
        \ ], '#1')
endfunction


function s:suite.range()
  call setline(1, [
        \   'foo ',
        \   'bar ',
        \   'baz ',
        \   'qux ',
        \ ])
  2,3 Strip
  call g:assert.equals(getline(1, '$'), [
        \   'foo ',
        \   'bar',
        \   'baz',
        \   'qux ',
        \ ], '#1')
endfunction
