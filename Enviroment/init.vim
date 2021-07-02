function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

if exists('g:vscode')
    " VSCode extension
else
    " ordinary neovim
endif
call plug#begin()
" use normal easymotion when in vim mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" use vscode easymotion when in vscode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
call plug#end()

let g:EasyMotion_do_mapping = 0 " Disable default mappings

map  s <Plug>(easymotion-bd-w)
nnoremap d "_d
vnoremap d "_d
nnoremap c "_c
vnoremap c "_c
