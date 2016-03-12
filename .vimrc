set nocompatible
filetype off

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make',
      \     'mac' : 'make',
      \     'unix' : 'make',
      \    },
      \ }
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimfiler'

NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'Smooth-Scroll'
NeoBundle 'smartword'
NeoBundle 'JavaScript-syntax'
NeoBundle 'jQuery'
NeoBundle 'nginx.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'vtreeexplorer'
NeoBundle 'altercation/vim-colors-solarized'

NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'nathanaelkane/vim-indent-guides.git'
NeoBundle 'ujihisa/unite-colorscheme.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 'taglist.vim'

" 補完
NeoBundle 'teramako/jscomplete-vim.git'
NeoBundle 'javacomplete'

" タグHighLevelCmd
NeoBundle 'abudden/TagHighlight.git'
" Git
NeoBundle 'gregsexton/gitv.git'
" powerline
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
" let g:Powerline_symbols='compatible'


" Indent
set autoindent
set smartindent
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
syntax enable
" syntax on
" hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c

set background=dark
colorscheme solarized

let g:solarized_termcolors=256
let g:solarized_termtrans=1


" Edit
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

set expandtab

inoremap , ,<Space>

" 保存時に行末の空白を除去
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換
autocmd BufWritePre * :%s/\t/    /ge


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


" unite.vim
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" ブックマーク一覧
nnoremap <silent> ,ubl :<C-u>Unite bookmark<CR>
" ブックマークに追加
nnoremap <silent> ,uba :<C-u>UniteBookmarkAdd<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>

" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

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



" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_execute_file_list = {}
let g:vimfiler_execute_file_list['c']     = 'vim'
let g:vimfiler_execute_file_list['h']     = 'vim'
let g:vimfiler_execute_file_list['hpp']   = 'vim'
let g:vimfiler_execute_file_list['cpp']   = 'vim'
let g:vimfiler_execute_file_list['cc']    = 'vim'
let g:vimfiler_execute_file_list['rb']    = 'vim'
let g:vimfiler_execute_file_list['php']   = 'vim'
let g:vimfiler_execute_file_list['js']    = 'vim'
let g:vimfiler_execute_file_list['css']   = 'vim'
let g:vimfiler_execute_file_list['html']  = 'vim'
let g:vimfiler_execute_file_list['vim']   = 'vim'

" VimShell
nnoremap <silent> <Leader>vs :<C-u>VimShellPop -toggle<CR>



" NERD_commenter
let NERDSpaceDelims = 1
" ,c<Space>  comment toggle


" taglist
set tags=tags
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_Show_One_File = 1 "現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWindow = 1 "taglist が最後のウインドウなら vim を閉じる
"let Tlist_Enable_Fold_Column = 1 " 折り畳み
map <silent> <leader>tl :TlistToggle<CR>
let g:tlist_php_settings = 'php;c:class;d:constant;f:function'


" quickrun
" config all clear
let g:quickrun_config = {}
let g:quickrun_config['*'] = {}
" 横分割
let g:quickrun_config['*'] = {'split': ''}
" for java
let g:quickrun_config['java'] = {
    \ 'exec': ['javac -J-Dfile.encoding=utf-8 %o %s', '%c -Dfile.encoding=UTF-8 %s:t:r %a', ':call delete("%S:t:r.class")'],
    \ 'output_encode': 'utf-8',
    \ }

" Gitv
autocmd FileType git :setlocal foldlevel=99

