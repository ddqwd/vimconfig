
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim



"|set pythonthreehome=

let is_unix = has('unix')
let is_gui_win32 = has('gui_win32')
if is_gui_win32
	" Vim with all enhancements
	source $VIMRUNTIME/vimrc_example.vim
endif



function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
if is_gui_win32
" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
	if &diffopt !~# 'internal'
	  set diffexpr=MyDiff()
	endif
	set guifont=新宋体:h15:cGB2312:qDRAFT
endif

let filesuffix=fnamemodify(bufname("%"), ":t")

"au TextChanged *.go,*.cpp,*.c,*md w
"au InsertLeavePre *.go,*.cpp,*.c,*md w
set nu
set nobackup
set noundofile
set autoindent
set tabstop=4
set shiftwidth=4
set termguicolors
set laststatus=2
set stl=%F\ %m
set stl+=\ %y
set stl+=\ %P
set backspace=indent,eol,start
" unix download
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"windows download
" iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni $HOME/vimfiles/autoload/plug.vim -Force 

if is_unix
set dict+=/usr/share/dict/words
endif

call plug#begin()
	Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
	Plug 'SirVer/ultisnips'|  Plug 'honza/vim-snippets'
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
	Plug 'lervag/vimtex'
	Plug 'preservim/tagbar'
	"coloscheme
	Plug 'jacoborus/tender.vim'
	Plug 'mhartington/oceanic-next'
	Plug 'rakr/vim-one'
	Plug 'arcticicestudio/nord-vim'
        Plug 'tomasr/molokai'
	Plug 'altercation/vim-colors-solarized'
	"https://github.com/ycm-core/YouCompleteMe
	Plug 'ycm-core/YouCompleteMe'

"	Plug 'godlygeek/tabular'
"	Plug 'preservim/vim-markdown'
    Plug 'tikhomirov/vim-glsl'
call plug#end()

set ignorecase
set smartcase
"encode
"
set encoding=utf-8

"tarbar
nmap <F8> :TagbarToggle<CR>

"autocmd VimEnter * NERDTree

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

let g:airline_theme='base16_ashes'
let g:airline#extensions#tabline#enabled = 1
"Use <F5> insert current date
" see link : https://vim.fandom.com/wiki/Insert_current_date_or_time
:nnoremap <F5> "=strftime("%c")<CR>P
:inoremap <F5> <C-R>=strftime("%c")<CR>


"" YouCompleteMe
"let g:ycm_key_list_previous_completion=['<Up>']
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_clangd_binary_path = "/usr/bin/clangd"
"|let g:ycm_global_ycm_extra_conf = '~/Downloads/mesa-18.3.6/build_debug/compile_commands.json'

highlight YCMErrorLine guibg=black ctermbg=red



let mapleader=','
nmap <leader>yfw <Plug>(YCMFindSymbolInWorkSpace)
nmap <leader>yfd <Plug>(YCMFindSymbolInDocument)
nmap <leader>gi :YcmCompleter GoToInclude<CR>
nmap <leader>gd :YcmCompleter GoToDeclaration<CR>
nmap <leader>gf :YcmCompleter GoToDefinition<CR>
nmap <leader>gp :YcmCompleter GoToImplementation<CR>
nmap <leader>gc :YcmCompleter GoToCallers<CR>
nmap <leader>gr :YcmCompleter GoToReferences<CR>



" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"

colorscheme OceanicNext

set path+=/home/shiji/Downloads/mesa-18.3.6/**
