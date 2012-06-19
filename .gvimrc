set guifontwide=Osaka:h11
set guifont=Osaka-Mono:h13
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=#666666
au BufNewFile, BufRead * match ZenkakuSpace /　/
set showtabline=2
set columns=94
set lines=42
set cmdheight=2
set transparency=3
map  gw :macaction selectNextWindow:
map  gW :macaction selectPreviousWindow:
set guioptions-=T
colorscheme molokai
