function! myspacevim#after() abort
  set mouse=""
  " ttymouse not working with neovim?
  " set ttymouse=""
  " set foldmethod=indent
  let g:neomake_python_enabled_makers = ['python', 'flake8']
  let g:neoformat_enabled_python = ['black']
endfunction
