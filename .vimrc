" vim: ft=vim
" rcns vimrc

" {{{1 settings
set nocompatible		" Use Vim defaults instead of 100% vi compatibility
"set t_Co=256			" support 256color terminals
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

" default comment symbols
let g:StartComment="#"
let g:EndComment=""

let g:is_posix=1

" vundle {{{1
filetype off                    " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle
call vundle#begin()

Plugin 'gmarik/vundle'          " let Vundle manage Vundle, required
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'klen/python-mode'
Plugin 'scrooloose/nerdtree'
"Plugin 'bash-support.vim'
Plugin 'renamer.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'vim-scripts/vimwiki'

" All of your Plugins must be added before the following line
call vundle#end()               " required
filetype plugin indent on       " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" {{{1 look
" set 256 colors if supported by terminal
if $TERM =~ "-256color"
  set t_Co=256
    if &diff
        set background=dark
        colorscheme peaksea
    else
        colorscheme base16-default
    endif
else
  colorscheme default
endif

" set the window title in screen
"if $STY != ""
"  set t_ts=k
"  set t_fs=\
"endif

set showcmd			" display incomplete commands
set noshowmode			" show current mode
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
set statusline=%F%m%r%h%w\ \|\ format:%{&ff}\ \|\ type:%Y\ \|\ pos:%4l,%4v\ \|\ lines:%L\ \|\ %{fugitive#statusline()}\ %=%3p%%


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
set expandtab			" insert spaces instead of tab chars
set tabstop=8			" a n-space tab width
set softtabstop=4		" counts n spaces when DELETE or BACKSPACE is used
set shiftwidth=4		" allows the use of < and > for VISUAL indenting
set shiftround			" shift to certain columns, not just n spaces
set noautoindent		" auto indents next new line
"set copyindent			" autoindent uses the same chars as prev
"set cindent			" Automatic program indenting
set cinkeys-=0#			" Comments don't fiddle with indenting
set cino=(0			" Indent newlines after opening parenthesis
filetype plugin indent on	" use file type based indentation

" {{{1 backup
set backup			" keep a backup file
set backupdir=/tmp		" backup dir
set directory=/tmp		" swap file directory
set backupskip+=*.gpg		" don't save backups of *.gpg files

" {{{1 keymapping
" unmap annoying keys
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" quicker window navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" quicker buffer navigation
nnoremap <C-n> :next<CR>
nnoremap <C-p> :prev<CR>

" comment/uncomment a visual block
vmap <C-c> :call CommentLines()<CR><CR>

" vimdiff keybinds
nmap <F7> [czz			" jump to previous diff code
nmap <F8> ]czz			" jump to next diff code

inoremap <F6> <C-R>=strftime('%a %d.%m.%Y %H:%M')<CR><CR>
set pastetoggle=<F5>		" stop indenting when pasting with the mouse 

" {{{1 functions
function! CommentLines()
  try
    execute ":s@^".g:StartComment."@\@g"
    execute ":s@".g:EndComment."$@@g"
  catch
    execute ":s@^@".g:StartComment."@g"
    execute ":s@$@".g:EndComment."@g"
  endtry
endfunction

function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

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

if has('autocmd')
    " vim itself
    au FileType vim let g:StartComment = "\""
    au BufWritePost ~/.vimrc source %

    " filetype detection for gmsh files
    augroup filetypedetect
        au! BufRead,BufNewFile *.geo,*.GEO        setfiletype gmsh
    augroup END
 
    " gpg encrypted files
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

    " Airline Customization
    "autocmd VimEnter * call AirlineInit()
endif

" {{{1 plugin options
" {{{2 latex suite

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" {{{2 gist
let g:gist_clip_command='xclip -selection clipboard'
let g:gist_browser_command = 'chromium %URL% &'

" {{{2 airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

function! AirlineInit()
  let g:airline_section_a = airline#section#create(['mode'])
  let g:airline_section_b = airline#section#create_left(['%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['ffenc'])
  let g:airline_section_z = airline#section#create_right(['%l', '%c'])
endfunction

" {{{2 nerdtree
map <F3> :NERDTreeToggle<CR>

" {{{2 python-mode
" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
let g:pymode_rope = 1

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0
