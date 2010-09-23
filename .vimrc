" vim: ft=vim
" rcns vimrc

" tips
" Capitalize the first character of all words -> :s/\<[a-z]/\u&/g

" {{{1 settings
set nocompatible		" Use Vim defaults instead of 100% vi compatibility
set t_Co=256			" support 256color terminals
set encoding=utf-8		" UTF-8 by default
set backspace=indent,eol,start	" more powerful backspacing
set shell=/bin/sh		" default shell
set esckeys			" allow usage of curs keys within insert mode
set joinspaces			" insert two spaces after a period with every joining of lines
set nowrap			" don't wrap lines
set foldenable			" enable folding
set foldmethod=marker		" how folds are recognized
set formatoptions=tcqn1		" vi compatible formatting
set matchtime=2			" tenths of second to hilight matching parent
set modeline			" allow the last line to be a modeline
set modelines=5			" how many modelines can be used
set selection=inclusive		" selection method
set complete=.,t,i,b,w,k	" set matches for insert-mode completion
set infercase			" completion recognizes capitalization
set whichwrap=h,l,<,>,[,]	" allow jumping to their closing chars
set clipboard+=unnamed		" use system clipboard

" {{{1 look
set showcmd			" display incomplete commands
set showmode			" show current mode
set showmatch			" show the matching bracket for the last ')'
set ruler			" show the cursor position all the time
set number			" show line numbers
set numberwidth=2		" width of line number column
set cursorline			" highlight the current line
set wildmenu			" completion on the command line shows a menu
set wildchar=<TAB>		" the char used for "expansion" on the command line
set wildmode=longest:full,full	" how big the list should be
set shortmess=atI		" shorten message output in command line
set report=0			" show a report when N lines were changed, 0=show all
set previewheight=5		" height of preview window
set vb				" set visual bell instead of audio bell
set t_vb=			" no argument means no flash for visual bell
set splitbelow			" put new split windows below
set cmdheight=1			" cmdprompt height
set laststatus=2		" show status line
set statusline=%F%m%r%h%w\ \|\ format:%{&ff}\ \|\ type:%Y\ \|\ pos:%4l,%4v\ \|\ lines:%L\ \|%=%3p%%
colorscheme	zenburn

if has('mouse')
  set mouse=a
endif

" highlighting tabs, trailing white space and non braking spaces
" if &term !=# "linux"
"     set list listchars=tab:\→\ ,trail:·,nbsp:-
" endif

set history=50		" keep 50 lines of command line history
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" {{{1 scrolling
set scroll=4			" number of lines to scroll with ^U/^D
set scrolloff=3			" top/bottom cursor offset
set sidescrolloff=3		" left/right cursor offset

" {{{1 search
set incsearch			" do incremental searching
set ignorecase			" case-insensitive search
set smartcase			" search: use case if any caps used
set magic			" Use some magic in search patterns?  Certainly!

" {{{1 indenting
set noexpandtab			" Don't insert spaces instead of tab chars
set tabstop=8			" a n-space tab width
set softtabstop=4		" counts n spaces when DELETE or BCKSPCE is used
set shiftwidth=4		" allows the use of < and > for VISUAL indenting
set shiftround			" shift to certain columns, not just n spaces
set noautoindent		" auto indents next new line
set copyindent			" autoindent uses the same chars as prev
set cindent			" Automatic program indenting
set cinkeys-=0#			" Comments don't fiddle with indenting
set cino=(0			" Indent newlines after opening parenthesis
filetype plugin indent on	" use file type based indentation

" {{{1 backup
set backup			" keep a backup file
set backupdir=/tmp		" backup dir
set directory=/tmp		" swap file directory
set backupskip+=*.gpg		" don't save backups of *.gpg files

" {{{1 keymapping
nmap <F3> diffget
nmap <F4> diffput
nmap <F7> [czz
nmap <F8> ]czz
set pastetoggle=<F5>		" stop indenting when pasting with the mouse 

" {{{1 commands
command -range=% Sprunge :<line1>,<line2>write !curl -sF "sprunge=<-" http://sprunge.us | xclip

" {{{2 toggle spell check
let b:myLang=0
let g:myLangList=["nospell","de_de","en_us"]
function! ToggleSpell()
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction

nmap <silent> <F2> :call ToggleSpell()<CR>
imap <silent> <F2> <C-o>:call ToggleSpell()<CR>

" {{{1 autocommands
augroup encrypted
  au!
  " Disable swap files, and set binary file format before reading the file
  autocmd BufReadPre,FileReadPre *.gpg
    \ setlocal viminfo=
    \ setlocal noswapfile bin
  " Decrypt the contents after reading the file, reset binary file format
  " and run any BufReadPost autocmds matching the file name without the .gpg
  " extension
  autocmd BufReadPost,FileReadPost *.gpg
    \ execute "'[,']!gpg --decrypt --default-recipient-self" |
    \ setlocal nobin |
    \ execute "doautocmd BufReadPost " . expand("%:r")
  " Set binary file format and encrypt the contents before writing the file
  autocmd BufWritePre,FileWritePre *.gpg
    \ setlocal bin |
    \ '[,']!gpg --encrypt --default-recipient-self
  " After writing the file, do an :undo to revert the encryption in the
  " buffer, and reset binary file format
  autocmd BufWritePost,FileWritePost *.gpg
    \ silent u |
    \ setlocal nobin
augroup END

autocmd BufWrite *.pl
    \ %s/changed     => '.*/\="changed     => '" . strftime("%c") . "',"/e

" {{{1 latex suite

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
