function! myspacevim#after() abort
  set mouse=""
  set ttymouse=""
  set foldmethod=indent
  call gina#custom#command#option(
        \ 'commit', '-v|--verbose'
        \)
endfunction
