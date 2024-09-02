    set runtimepath^=~/.vim runtimepath+=~/.vim/after
    let &packpath = &runtimepath
    "source ~/.vimrc
    "
    "
    "

colorscheme evening

"unlet! skip_defaults_vim
""source $VIMRUNTIME/defaults.vim



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

set hls
set nu
set nobackup
set noundofile
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
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
	"Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
	"Plug 'SirVer/ultisnips'|  Plug 'honza/vim-snippets'
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
	"Plug 'lervag/vimtex'
	Plug 'preservim/tagbar'
	"coloscheme
	"Plug 'jacoborus/tender.vim'
	Plug 'mhartington/oceanic-next'
	"Plug 'rakr/vim-one'
	Plug 'arcticicestudio/nord-vim'
 	Plug 'nordtheme/vim'
    Plug 'tomasr/molokai'
	"Plug 'altercation/vim-colors-solarized'
	"https://github.com/ycm-core/YouCompleteMe
	"Plug 'ycm-core/YouCompleteMe'
    "Plug 'vim-latex/vim-latex'
    "
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'lewis6991/gitsigns.nvim'

"	Plug 'godlygeek/tabular'
"	Plug 'preservim/vim-markdown'
    "Plug 'tikhomirov/vim-glsl'
	Plug 'github/copilot.vim'
"    Plug 'powerman/vim-plugin-viewdoc'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'sindrets/diffview.nvim'
    "Plug 'cappyzawa/trim.nvim'
    "
    Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
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
"nmap <leader>yfw <Plug>(YCMFindSymbolInWorkSpace)
"nmap <leader>yfd <Plug>(YCMFindSymbolInDocument)
"nmap <leader>gi :YcmCompleter GoToInclude<CR>
"nmap <leader>gd :YcmCompleter GoToDeclaration<CR>
"nmap <leader>gf :YcmCompleter GoToDefinition<CR>
"nmap <leader>gp :YcmCompleter GoToImplementation<CR>
"nmap <leader>gc :YcmCompleter GoToCallers<CR>
"nmap <leader>gr :YcmCompleter GoToReferences<CR>
"nmap <leader>fi :YcmCompleter FixIt<CR>
"nmap <leader>ft :YcmCompleter Format<CR>


nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>[g <Plug>(coc-diagnostic-prev)


" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>


" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"

colorscheme OceanicNext

set mouse=r
"set path+=/home/shiji/Downloads/mesa-18.3.6/**
set path+=/home/shiji/mesa/src

"alphsubs ---------------------- {{{
        execute "digraphs ks " . 0x2096
        execute "digraphs as " . 0x2090
        execute "digraphs es " . 0x2091
        execute "digraphs hs " . 0x2095
        execute "digraphs is " . 0x1D62
        execute "digraphs ks " . 0x2096
        execute "digraphs ls " . 0x2097
        execute "digraphs ms " . 0x2098
        execute "digraphs ns " . 0x2099
        execute "digraphs os " . 0x2092
        execute "digraphs ps " . 0x209A
        execute "digraphs rs " . 0x1D63
        execute "digraphs ss " . 0x209B
        execute "digraphs ts " . 0x209C
        execute "digraphs us " . 0x1D64
        execute "digraphs vs " . 0x1D65
        execute "digraphs xs " . 0x2093
"}}}
"
"  function! ClangFormatOnSave()
"    " Only format files that have a .clang-format in a parent folder
"    if !empty(findfile('.clang-format', '.;'))
"      let l:formatdiff = 1 " Only format lines that have changed
"      "py3f /usr/share/clang/clang-format.py
"	  py3f /usr/share/clang/clang-format-7/clang-format.py
"    endif
"  endfunction
"
"  autocmd BufWritePre *.h,*.c,*.cc,*.cpp call ClangFormatOnSave()
"augroup END

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='xelatex'
let g:Tex_CompileRule_dvi='xelatex -interaction=nonstopmode -file-line-error-style "$*"'
let g:Tex_IgnoreLevel=8
"let g:Tex_IgnoredWarnings+='Package fontspec Warning'
let g:Tex_GotoError=0

nmap <leader>sfd :set foldmethod=syntax
nmap <leader>sufd :set nofoldenable


"nmap <leader>pr oprintf( "the unanlaysis circumstance happend , need to handle : %s : %s : %d  
"\n", __FILE__, __func__, __LINE__
");
"nmap <leader>pr1 oprintf(" %s %s %d: \n", __FILE__, __func__, __LINE__,
");

nmap <leader>sfd :set foldmethod=syntax
nmap <leader>sufd :set nofoldenable
"call plug#begin()
"
"" List your plugins here
"Plug 'tpope/vim-sensible'
"" Use release branch (recommended)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"" Or build from source code by using npm
""Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
"
"call plug#end()
" 
lua << EOF
require('gitsigns').setup()


require('gitsigns').setup{
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)
    map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hu', gitsigns.undo_stage_hunk)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end)
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
    map('n', '<leader>hd', gitsigns.diffthis)
    map('n', '<leader>hD', function() gitsigns.diffthis('~') end)
    map('n', '<leader>td', gitsigns.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}
EOF



highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

set clipboard+=unnamedplus


command! -nargs=+ GetCompileCommands lua print(vim.inspect(require('coc').getCompileCommands()))
