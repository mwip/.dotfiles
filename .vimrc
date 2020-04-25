set nocompatible

let mapleader=" "

set clipboard+=unnamedplus

call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tomasiser/vim-code-dark'
" Code Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
call plug#end()

"Split navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

set laststatus=2
set t_Co=256
syntax on
set number
set backspace=indent,eol,start

" Vim-airline
let g:airline#extensions#wordcount#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline_theme = 'codedark'

" ------COC SETTINGS------
" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
let g:coc_global_extensions = [
  \ 'coc-r-lsp'
  \ ]

