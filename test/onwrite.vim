let s:suite = themis#suite('onwrite')


function s:suite.before_each()
  % bwipeout!
  let g:strip_onwrite = 'confirm'
  unlet! g:strip_confirm_choice
  filetype off
  filetype plugin indent off
endfunction

function s:suite.after()
  call self.before_each()
endfunction


function s:suite.always()
  let g:strip_onwrite = 'always'
  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  write
  call g:assert.equals(getline(1, '$'), ['some'], '#1')
endfunction


function s:suite.never()
  let g:strip_onwrite = 'never'
  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  write
  call g:assert.equals(getline(1, '$'), ['some '], '#1')
endfunction


function s:suite.buf_local()
  let g:strip_onwrite = 'always'
  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  let b:strip_onwrite = 'never'
  write
  call g:assert.equals(getline(1, '$'), ['some '], '#1')
endfunction


function s:suite.confirm_Yes_No()
  let g:strip_onwrite = 'confirm'

  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  let g:strip_confirm_choice = 1  " Yes
  write
  call g:assert.equals(getline(1, '$'), ['some'], '#1')

  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  let g:strip_confirm_choice = 2  " No
  write
  call g:assert.equals(getline(1, '$'), ['some '], '#2')
endfunction


function s:suite.confirm_Always()
  let g:strip_onwrite = 'confirm'
  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  call g:assert.key_not_exists(b:, 'strip_onwrite', '#1')
  let g:strip_confirm_choice = 3  " Always
  write
  call g:assert.equals(getline(1, '$'), ['some'], '#2')
  call g:assert.equal(b:strip_onwrite, 'always', '#3')
endfunction


function s:suite.confirm_Never()
  let g:strip_onwrite = 'confirm'
  let tempname = tempname()
  call writefile(['some '], tempname)
  edit `=tempname`
  call g:assert.key_not_exists(b:, 'strip_onwrite', '#1')
  let g:strip_confirm_choice = 4  " Never
  write
  call g:assert.equals(getline(1, '$'), ['some '], '#2')
  call g:assert.equal(b:strip_onwrite, 'never', '#3')
endfunction


function s:suite.markdown()
  let tempname = tempname() .. '.md'
  call writefile(['some '], tempname)
  edit `=tempname`
  call g:assert.key_not_exists(b:, 'strip_onwrite', '#1')

  filetype plugin on
  let tempname = tempname() .. '.md'
  call writefile(['some '], tempname)
  edit `=tempname`
  call g:assert.equal(b:strip_onwrite, 'never', '#2')
endfunction
