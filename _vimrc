" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
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


colorscheme evening
set guifont=新宋体:h15:cGB2312:qDRAFT
"au TextChanged *.go,*.cpp,*.c,*md w
"au InsertLeavePre *.go,*.cpp,*.c,*md w
set nu
set nobackup


"
set autoindent
set tabstop=4
set shiftwidth=4

let is_win32= has('win32')
let is_unix = has('unix')
" unix download
"curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"windows download
" iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim | ni $HOME/vimfiles/autoload/plug.vim -Force
" must install python3.11
" https://www.python.org/
"
if is_unix
let PLUG = expand("$HOME/.vim/autoload/plug.vim")
else
	if is_win32
		let PLUG = expand("$HOME/vimfiles/autoload/plug.vim")
	else
		echo "unkonwn platform"
	endif
endif

if !filereadable(PLUG)
	echo "vim-plug is not installed " . PLUG 
else
	call plug#begin()
		Plug 'SirVer/ultisnips'|  Plug 'honza/vim-snippets'
		Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
	call plug#end()
endif


"autocmd VimEnter * NERDTree

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif