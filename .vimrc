set autoindent
set tabstop=4
set shiftwidth=4
set termguicolors
colo evening
call plug#begin()
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'morhetz/gruvbox'

call plug#end()
set nu
autocmd FileReadPre *.cpp,*.c set cindent
set path+=/usr/include/x86_64-linux-gnu/
