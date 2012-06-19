set nocompatible
filetype plugin indent off
filetype off
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc.git'
"cd ~/.vim/bundle/vimproc, make -f your_machines_makefile
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'git://github.com/Shougo/neocomplcache-snippets-complete.git'
NeoBundle 'Shougo/vimfiler'

NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'Smooth-Scroll'
NeoBundle 'smartword'
" NeoBundle 'SQLUtilities'
NeoBundle 'taglist.vim'
" NeoBundle 'haml.zip'
" NeoBundle 'JavaScript-syntax'
" NeoBundle 'jQuery'
" NeoBundle 'nginx.vim'
NeoBundle 'scrooloose/syntastic'
" NeoBundle 'The-NERD-tree'
NeoBundle 'vtreeexplorer'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'tomasr/molokai'
" NeoBundle 'TwitVim'

NeoBundle 'git://github.com/thinca/vim-quickrun.git'
" NeoBundle 'git://github.com/tpope/vim-markdown.git'
" open browser - .mdのquickrun時に使用
" NeoBundle 'git://github.com/tyru/open-browser.vim.git'
NeoBundle 'git://github.com/tpope/vim-fugitive.git'
NeoBundle 'YankRing.vim'
NeoBundle 'git://github.com/nathanaelkane/vim-indent-guides.git'
NeoBundle 'git://github.com/ujihisa/unite-colorscheme.git'
NeoBundle 'git://github.com/tpope/vim-surround.git'
NeoBundle 'taglist.vim'
NeoBundle 'errormarker.vim'

" 補完
NeoBundle 'git://github.com/Shougo/neocomplcache-clang_complete.git'
NeoBundle 'git://github.com/teramako/jscomplete-vim.git'
NeoBundle 'javacomplete'

" タグHighLevelCmd
NeoBundle 'git://github.com/abudden/TagHighlight.git'

" C/C++
NeoBundle 'git://github.com/vim-scripts/CCTree.git'
NeoBundle 'git://github.com/mattn/quickrunex-vim.git'

" memo
" NeoBundle 'git://github.com/fuenor/qfixhowm.git'
" NeoBundle 'git://github.com/glidenote/memolist.vim.git'

" Git
NeoBundle 'git://github.com/gregsexton/gitv.git'


filetype plugin indent on
filetype plugin on

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
set ruler
" let g:Powerline_symbols = 'fancy'

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
hi PmenuSel cterm=reverse ctermfg=33 ctermbg=222 gui=reverse guifg=#3399ff guibg=#f0e68c
set background=dark
colorscheme molokai


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


" Encoding
set ff=unix
set encoding=utf-8
set termencoding=utf-8

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
" let g:unite_enable_start_insert=1
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

" neocomplecache.vim
" set completeopt = menuone
" NeoComplCacheを有効にする
let g:neocomplcache_enable_at_startup = 1
" 補完が自動で開始される文字数
let g:neocomplcache_auto_completion_start_length = 3
" smarrt case有効化。 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplcache_enable_smart_case = 1
" camle caseを有効化。大文字を区切りとしたワイルドカードのように振る舞う
let g:neocomplcache_enable_camel_case_completion = 1
" _(アンダーバー)区切りの補完を有効化
let g:neocomplcache_enable_underbar_completion = 1
" シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplcache_min_syntax_length = 3
" neocomplcacheを自動的にロックするバッファ名のパターン
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
" -入力による候補番号の表示
let g:neocomplcache_enable_quick_match = 1
" 補完候補の一番先頭を選択状態にする(AutoComplPopと似た動作)
let g:neocomplcache_enable_auto_select = 1
" ポップアップメニューで表示される候補の数。初期値は100
let g:neocomplcache_max_list = 50

" DTと入力するとD*T*と解釈され、DateTime等にマッチする。
let g:neocomplcache_enable_camel_case_completion = 0
" m_sと入力するとm*_sと解釈され、mb_substr等にマッチする。
let g:neocomplcache_enable_underbar_completion = 0


let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scala' : $HOME.'/.vim/dict/scala.dict',
    \ 'java' : $HOME.'/.vim/dict/java.dict',
    \ 'c' : $HOME.'/.vim/dict/c.dict',
    \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
    \ 'perl' : $HOME.'/.vim/dict/perl.dict',
    \ 'php' : $HOME.'/.vim/dict/php.dict',
    \ 'scheme' : $HOME.'/.vim/dict/scheme.dict',
    \ 'vim' : $HOME.'/.vim/dict/vim.dict'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
" 日本語を補完候補として取得しないように
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()


" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>,  <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()


" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType ctp setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
let g:jscomplete_use = ['dom', 'moz']
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java setlocal completefunc=javacomplete#CompleteParamsInfo

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
"autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'


" ユーザー定義スニペット保存ディレクトリ
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'
noremap <Leader>nes :<C-u>NeoComplCacheEditSnippets<CR>

" use neocomplcache & clang_complete
" add neocomplcache option
let g:neocomplcache_force_overwrite_completefunc=1
" add clang_complete option
let g:clang_complete_auto=1
" NeoComplCache-Clang設定 "{{{
" let g:neocomplcache_clang_use_library  = 1
" " libclang.so を置いたディレクトリを指定
" let g:neocomplcache_clang_library_path = '/usr/share/clang'

" " Include するディレクトリは各自の環境に合わせて設定
" let g:neocomplcache_clang_user_options =
    " \ '-I /usr/include/ '.
    " \ '-fms-extensions -fgnu-runtime '.
    " \ '-include malloc.h '"}}}


" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_execute_file_list = {}"{{{
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
let g:vimfiler_execute_file_list['vim']   = 'vim'"}}}

" YankRing
let g:yankring_history_dir = expand('$HOME')."/.yankring/"
let g:yankring_history_file = '.yankring_history'"{{{
nnoremap <silent> <F7> :YRShow<CR>
let g:yankring_max_history = 10
let g:yankring_window_height = 13"}}}

" NEEDTree"{{{
" nnoremap nt :NERDTreeToggle<CR>
" 隠しファイルを表示
" let NERDTreeShowHidden = 1"}}}


" memolist
let g:memolist_path = "./.vim/work"


" TwitVim"{{{
" let twitvim_count = 100
" nnoremap ,tw :<C-u>PosttoTwitter<CR>
" nnoremap ,tf :<C-u>FriendsTwitter<CR><C-w>
" nnoremap ,tu :<C-u>UserTwitter<CR><C-w>
" nnoremap ,tr :<C-u>RepliesTwitter<CR><C-w>
" nnoremap ,tl :<C-u>RefreshTwitter<CR><C-w>
" nnoremap ,tn :<C-u>NextTwitter<CR>
" nnoremap ,tp :<C-u>PreviousTwitter<CR>

" autocmd FileType twitvim call s:twitvim_my_settings()
" function! s:twitvim_my_settings()
    " set nowrap
" endfunction"}}}

" NERD_commenter
let NERDSpaceDelims = 1
" ,c<Space>  comment toggle


" taglist
set tags=tags
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags""{{{
let Tlist_Show_One_File = 1 "現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWindow = 1 "taglist が最後のウインドウなら vim を閉じる
"let Tlist_Enable_Fold_Column = 1 " 折り畳み
map <silent> <leader>tl :TlistToggle<CR>
let g:tlist_php_settings = 'php;c:class;d:constant;f:function'"}}}


" errormarker
let g:errormarker_errortext = '!!'
let g:errormarker_warningtext = '??'"{{{
let g:errormarker_errorgroup = 'Error'
let g:errormarker_warninggroup = 'Todo'
" if has('win32') || has('win64')
    " let g:errormarker_erroricon = expand('~/.vim/bundle/errormarker.vim/signs/err.bmp')
    " let g:errormarker_warningicon = expand('~/.vim/bundle/errormarker.vim/signs/warn.bmp')
" else
    " let g:errormarker_erroricon = expand('~/.vim/bundle/errormarker.vim/signs/err.png')
    " let g:errormarker_erroricon = expand('~/.vim/bundle/errormarker.vim/signs/err.png')
" endif
"}}}

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

" open browser
" let g:quickrun_config['markdown'] = {"{{{
    " \ 'type': 'markdown/pandoc',
    " \ 'outputter': 'browser',
    " \ 'cmdopt': '-s'
    " \ }"}}}


" indent-guides
" let g:indent_guides_enable_on_vim_startup = 1"{{{
" let g:indent_guides_color_change_percent = 20
" let g:indent_guides_guide_size = 1
" let g:indent_guides_auto_colors = 1
" autocmd VimEnter, Colorscheme * :hi IndentGuidesOdd  guibg=red ctermbg=lightblue
" autocmd VimEnter, Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=lightgrey"}}}



" OS判断
if has('mac')
    " let g:Powerline_symbols = 'fancy'"{{{

    " 起動時に新しいファイルが読まれたら実行
    " autocmd BufRead * :echo "hello"

    " 外部ファイルを読み込んで実行
    " :source ~/.sample.vim
    " autocmd BufRead * :source ~/.sample.vim"}}}

    " 失敗
    " nmap <Leader>z :<C-u>Unite echo "hello"<CR>
    nmap <Leader>z :<C-u>echo ",zで出力されたでー"<CR>


    nmap <Leader>x :<C-u>source ~/.sample.vim<CR>

    " $HOME/.vim/や、$HOME/vimfiles/に置かれたファイルを読み込む"{{{
    " $HOME/.vim/sample/.sample.vim
    " nmap <Leader>a :<C-u>runtime sample/.sample.vim<CR>"}}}


    " 練習用vim file
    source ~/practice1.vim
    nmap <Leader>p :%call g:Makeyouvim()<CR>
    nmap <Leader>p0 :call g:Makeyouvim()<CR>"{{{
    nmap <Leader>p1 :3,7call g:Makeyouvim()<CR>
    nmap <Leader>p2 :%call g:MakeYouVim()<CR>"}}}

    " <expr>を指定する事で、insertモードで関数の戻り値を入力文字としてとして出力
    inoremap <expr> <C-y> g:InsertCall()

    command! MakeCmd :call g:Makecmd()

    command! -nargs=? -range=% HighLevelCmd :call g:HighLevelCmd(<count>, <line1>, <line2>, <f-args>)

    " <q-args>は引数を式で使えるように"でクォートされる
    " 引数がない時は空文字列
    command! -nargs=* Hookfunc execute g:hookfunc(<q-args>)

    " ファイル名とかいろいろ取得する自作関数
    command! GetFileName :call g:getFileName()

    autocmd FocusGained * :call g:Highlight_cursor()

    syntax match txtTtile '^\*.*'
    highlight link txtTtile Title
" *kokokotest


    " 開発用vimrc読み込み用
    " augroup vimrc-local"{{{
        " autocmd!
        " " expand('<afile>:p:h') == '/User/tomo'
        " " autocmd BufNewFile,BufReadPost * echo expand('<afile>:p:h')
        " autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
    " augroup END
    " " 開発用vimrcコマンドで読み込み用
    " command! ReadVimrcLocal :call s:vimrc_local(expand('<afile>:p:h'))

    " function! s:vimrc_local(loc)
        " " let files = findfile('vimrc_local.vim', escape(a:loc, ' ') . ';', -1)
        " let files = findfile('vimrc_local.vim', './.vim/work/vim-plugins;', -1)
        " " echo files
        " for i in reverse(filter(files, 'filereadable(v:val)'))
            " source `=i`
            " " よくわからんが`=i`じゃないと無理
        " endfor
    " endfunction

    " if g:loaded_vimrc == 0
        " call s:vimrc_local(getcwd())
    " endif"}}}

    " plugin作成用
    " ==========================================
    let g:dayone_path = "$HOME/Dropbox/Journal.dayone/entries"
    " plugin.vim
    " ==========================================
    if &cp || exists("loaded_dayone_vim")
        finish
    endif
    let loaded_dayone_vim = 1

    " ユーザの初期設定を逃がす
    " let s:save_cpo = &cpo
    " set cpo&vim
    if !exists('g:dayone_path')
        let g:dayone_path = $HOME . "/dayone/entries"
    endif

    " コマンドの定義。
    " command! -nargs=0 DayOnePost :call g:dayonepost()

    " 退避していたユーザのデータをリカバリ
    " let &cpo = s:cpo_save

    " autoload.vim
    " =========================================
    if &cp || exists("g:autoloaded_dayone")
        finish
    endif
    let g:autoloaded_dayone= '1'

    " let s:cpo_save = &cpo
    " set cpo&vim

    function! g:dayonepost()
        let info = {
            \ 'date' : strftime("%Y-%m-%dT%H:%M:%SZ"),
            \ 'suffix' : "doentry",
            \ 'uuid' : substitute(system("uuidgen"), '\(-\|\W\)', '', 'g'),
            \}

        let g:dayone_path = expand(g:dayone_path,  ':p')
        if !isdirectory(g:dayone_path)
            try
                call mkdir(g:dayone_path,  'p')
            catch
                echo "Can't create '".g:dayone_path."'"
                finish
            endtry
        endif

        " let do_filename = escape(info['uuid'] . "." . info['suffix'], ' ')
        let do_filename = info['uuid'] . ".doentry"
        echo "Making that memo " . do_filename
        " &l:varname => local vim option
        " 編集中なら画面を割る/違うなら新しく開く
        " exe (&l:modified ? "sp" : "e") s:escarg(g:memolist_path . "/" . file_name)
        "
        " ==========================================================
        " 分割してファイル作成
        exe "sp" escape(g:dayone_path . "/" . do_filename , ' ')
        " echo do_filename

        " templete Array
        " let template = s:default_template
        let template = readfile(expand("$HOME/doentry.plist"), '')


        " command! -nargs=0 DoPost :call s:dayonepost()
        " echo template

        call append(0, ['testarray', 'test', 'aaaaa', 'centos'])

        " %call s:postdayone(template)

        " =================================
        " setlocal nonumber
        " setlocal background=light
        " setlocal filetype=txt
        " =================================
        " apply template
        " 0行目に文字列を挿入
        " let err = append(0,  s:apply_template(template,  info))

    endfunction

    command! DoPost :%call s:postdayone()

    " function! s:postdayone(template) range
    function! s:postdayone() range

        let template = readfile(expand("$HOME/doentry.plist"), '')
        " let l:i = len(a:template)
        let info = {
            \ 'date' : strftime("%Y-%m-%dT%H:%M:%SZ", localtime() - (60 * 60) * 9),
            \ 'suffix' : "doentry",
            \ 'uuid' : substitute(system("uuidgen"), '\(-\|\W\)', '', 'g'),
            \}

        let a_outputfile = escape(g:dayone_path . "/" . info['uuid'] . "." . info['suffix'], ' ')
        " echo a_outputfile
        " call writefile(a:template,  a_outputfile)
        " call writefile(a:template
            " \, a_outputfile)
        " let err = append(0,  s:apply_template(a:template,  info))
        let xxx = s:apply_template(template, info)
        let l:i = 0
        let l:j = 1
        execute ":redir! > " . a_outputfile
        while l:i < len(xxx)
            if xxx[l:i] =~ '\\*{{_text_}}\\*'
                let l:plist_tag = split(xxx[l:i], '\\*{{_text_}}\\*')
                while l:j < a:lastline + 1
                    if l:j == 1
                        " echo l:plist_tag[0] . getline(l:j)
                        " :silent! echon l:plist_tag[0] . getline(l:j) . "\n"
                        :silent! echon l:plist_tag[0] . s:escapeText(getline(l:j)) . "\n"
                    elseif l:j == a:lastline
                        " echo getline(l:j) . l:plist_tag[len(l:plist_tag) - 1]
                        :silent! echon s:escapeText(getline(l:j)) . l:plist_tag[len(l:plist_tag) - 1] . "\n"
                    else
                        " echo getline(l:j)
                        :silent! echon s:escapeText(getline(l:j)) . "\n"
                    endif
                    let l:j += 1
                endwhile
            else
                " echo xxx[l:i]
                :silent! echon xxx[l:i] . "\n"
            endif
            let l:i += 1
        endwhile
        redir END

        " len(xxx) xmlの長さ

    endfunction

    function! s:escapeText(x)
        let l:x = a:x
        let l:x = substitute(l:x,  '&',  '\&amp;',  'g')
        let l:x = substitute(l:x,  '<',  '\&lt;',  'g')
        let l:x = substitute(l:x,  '>',  '\&gt;',  'g')
        " let l:x = substitute(l:x,  "'",  '\&apos;',  'g')
        " let l:x = substitute(l:x,  '"',  '\&quot;',  'g')
        return l:x
    endfunction

    let s:default_template = [
        \ '<?xml version="1.0" encoding="UTF-8"?>',
        \ '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">',
        \ '<plist version="1.0">',
        \ '<dict>',
        \   "\t<key>Creation Date</key>",
        \   "\t<date>{{_date_}}</date>",
        \   "\t<key>Entry Text</key>",
        \   "\t<string>{{_text_}}</string>",
        \   "\t<key>Starred</key>",
        \   "\t<false/>",
        \   "\t<key>UUID</key>",
        \   "\t<string>{{_uuid_}}</string>",
        \ '</dict>',
        \ '</plist>',
        \]

    function! s:apply_template(template,  info)
        let l:pat = '{{_\([-./[:lower:]_~]\+\)_}}'
        return map(copy(a:template), "
            \  substitute(v:val, l:pat,
            \  '\\=has_key(a:info, submatch(1)) ? a:info[submatch(1)] : submatch(0)', 'g')
            \")
        " map(v:val)全配列要素に対して変換する
        " substitute(base(v:val), pattern, string, flag )
    endfunction
    " let &cpo = s:cpo_save

endif


