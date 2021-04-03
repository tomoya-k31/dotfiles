set encoding=utf-8 fileencoding=utf-8 termencoding=utf-8     " Saving and encoding
set nobackup nowritebackup noswapfile autoread               " No backup or swap
set hlsearch incsearch ignorecase smartcase                  " Search
set wildmenu                                                 " Completion
set backspace=indent,eol,start                               " Sane backspace
set mouse=a                                                  " Enable mouse for all modes settings
set nomousehide                                              " Don't hide the mouse cursor while typing
set mousemodel=popup                                         " Sight-click pops up context menu
set ruler                                                    " Show cursor position in status bar
set number                                                   " Show line numbers on left
set scrolloff=10                                             " Scroll the window so we can always see 10 lines around the cursor
set textwidth=80                                             " Show a vertical line at the 79th character
set printoptions=paper:letter                                " Use letter as the print output format
set guioptions-=T                                            " Turn off GUI toolbar (icons)
set guioptions-=r                                            " Turn off GUI right scrollbar
set guioptions-=L                                            " Turn off GUI left scrollbar
set winaltkeys=no                                            " Turn off alt shortcuts
set laststatus=2                                             " Always show status bar
set nowrap                                                   " Disable line wrapping
set clipboard+=unnamedplus                                   " Use the system keyboard
set noshowmode                                               " Echodoc compatibility
set hidden                                                   " For LSP server
set shiftwidth=4 tabstop=4 softtabstop=4                     " Set tab width to 4 characters
set expandtab                                                " Expand all tabs to spaces
set autoindent                                               " Automatically indent
set list                                                     " Show whitespace
set listchars=tab:‣\ ,trail:·                                " Tweak whitespace visualization
set signcolumn=yes                                           " Always show lint column
set colorcolumn=80,120                                       " Show columnhighlights
syntax on
