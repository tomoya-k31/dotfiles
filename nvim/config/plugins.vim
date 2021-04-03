if &compatible
  set nocompatible
endif

" Required:
set runtimepath+=$CACHE/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$CACHE/dein')
  call dein#begin('$CACHE/dein')

  " Required:
  call dein#add('$CACHE/dein/repos/github.com/Shougo/dein.vim')
  " Extend the installation timeout to allow time for markdown composer build to omplete
  let g:dein#install_process_timeout=300

  " Theme
  call dein#add('mhartington/oceanic-next')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')

  " Directory
  call dein#add('preservim/nerdtree')
  call dein#add('ryanoasis/vim-devicons')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" Install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
