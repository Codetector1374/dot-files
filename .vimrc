" Ensure that we are in modern vim mode, not backwards-compatible vi mode
set nocompatible
set backspace=indent,eol,start

" Helpful information: cursor position in bottom right, line numbers on
" left
set ruler
set number

set tabstop=4
set softtabstop=0 expandtab
set shiftwidth=4
"Enable filetype detection and syntax hilighting
syntax on
filetype on
filetype indent on
filetype plugin on

" Nix use 2 tab
autocmd FileType nix set tabstop=2
autocmd FileType nix set shiftwidth=2

" Indent as intelligently as vim knows how
set smartindent

" Show multicharacter commands as they are being typed
set showcmd
