if has('vim_starting')
    " 初回起動時のみruntimepathにNeoBundleのパスを指定する
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'Smooth-Scroll'
NeoBundle 'smartword'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tomasr/molokai'
NeoBundle 'nathanaelkane/vim-indent-guides.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'gregsexton/gitv.git'
NeoBundle 'powerline/powerline.git',  { 'rtp' : 'powerline/bindings/vim'}

call neobundle#end()

filetype plugin indent on
filetype plugin on

" Encoding
set ff=unix
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,sjis

" Basics
let mapleader = ","
set scrolloff=5
set textwidth=0
set nobackup
set autoread
set noswapfile
set hidden
set backspace=indent,eol,start
set formatoptions=lmoq
set vb t_vb=
set browsedir=buffer
set whichwrap=b,s,h,l,<,>,[,]
set showcmd
set showmode
set viminfo='50,<1000,s100,\"50
" set modelines=0                  " モードラインは無効
set fileformats=unix,dos,mac       " 改行コードの自動判別. 左側が優先される
set ambiwidth=double               " □や○文字が崩れる問題を解決

" OSのクリップボードを使用する
set clipboard+=unnamed,autoselect
" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

" StatusLine
set laststatus=2
set showtabline=2
set noshowmode
set ruler

let g:Powerline_symbols='fancy'
let g:powerline_pycmd='py'

" Indent
set autoindent    " 改行時に前の行のインデントを継続する
set smartindent   " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set cindent

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=4 shiftwidth=4 softtabstop=0

" Apperance
set showmatch
set number
set nowrap
set list
set listchars=tab:>.,trail:_,extends:>,precedes:<
set display=uhex
" http://www.kaoriya.net/blog/2014/03/30/
set noundofile

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

set cursorline
" current window only set cursorline
augroup cch
    autocmd! cch
    autocmd WinLeave * set nocursorline
    autocmd WinEnter,BufRead * set cursorline
augroup END

hi clear CursorLine
hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

set lazyredraw
set ttyfast

" Complete
set wildmenu
set wildchar=<tab>
set wildmode=list:full
set history=1000
set complete+=k            " 補完に辞書ファイル追加

" Search
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
nmap <ESC><ESC> :nohlsearch<CR><ESC>

" Colors
" syntax on
" hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c

set background=dark

"----------------------------------------------------------
" molokaiの設定
"----------------------------------------------------------
if neobundle#is_installed('molokai') " molokaiがインストールされていれば
    colorscheme molokai " カラースキームにmolokaiを設定する
endif

set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける

" Edit
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

set expandtab " タブ入力を複数の空白入力に置き換える

" ,の後ろにスペース追加
" inoremap , ,<Space>

" 保存時に行末の空白を除去
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換
" autocmd BufWritePre * :%s/\t/    /ge

autocmd FileType cvs :set fileencoding=euc-jp
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8

autocmd FileType vim :setlocal foldmethod=marker
autocmd FileType c :setlocal foldmethod=syntax
autocmd FileType cpp :setlocal foldmethod=syntax

" Moving - INSERT MODEで「<C-v>+方向キー」で入力
inoremap OB <Down>
inoremap OA <Up>
inoremap OD <Left>
inoremap OC <Right>

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType ctp setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
let g:jscomplete_use = ['dom', 'moz']
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java setlocal completefunc=javacomplete#CompleteParamsInfo

" Gitv
autocmd FileType git :setlocal foldlevel=99

" クリップボードからペーストする時だけインデントしないように
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"

    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction

    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
