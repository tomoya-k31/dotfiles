" Theme

" https://github.com/mhartington/oceanic-next
" For Neovim 0.1.3 and 0.1.4
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" for vim 8
" Or if you have Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" " Required for tmux
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" " Required for tmux
endif

syntax enable
" for vim 7
set t_Co=256

" If your terminal and setup supports it, you can enable italics and bold fonts with the following setting
syntax on
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

" Enable line highlighting
set cursorline

" airline
let g:airline_theme='oceanicnext'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#use_vcscommand = 0 " Disable VCS integration
let g:airline_section_b = ''                       " Disable git integration
let g:airline_section_x = ''                       " Disable file type
let g:airline_section_z = ''                       " Disable file position
