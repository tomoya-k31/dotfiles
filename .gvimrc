" set guifontwide=Osaka:h11
set guifontwide=Ricty\ for\ Powerline:h12
" set guifont=Osaka-Mono:h13
set guifont=Ricty\ for\ Powerline:h14
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile, BufRead * match ZenkakuSpace /　/
set showtabline=0
set columns=160
set lines=45
set linespace=1
set cmdheight=1
set transparency=15
map  gw :macaction selectNextWindow:
map  gW :macaction selectPreviousWindow:
set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=
set guioptions-=b
let g:Powerline_symbols = 'fancy'
colorscheme molokai

