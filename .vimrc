" vim: ft=vim
" rcns vimrc

" {{{1 settings
set nocompatible		" Use Vim defaults instead of 100% vi compatibility
"set t_Co=256			" support 256color terminals
set encoding=utf-8		" UTF-8 by default
set backspace=indent,eol,start	" more powerful backspacing
set shell=/bin/sh		" default shell
set esckeys			" allow usage of curs keys within insert mode
set nojoinspaces		" don't insert two spaces after a period with every joining of lines
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
set hidden                      " allows buffers to be hidden if a buffer is modified
set confirm                     " confirm dropping unsaved buffers
set synmaxcol=1000              " maximum line length for syntax highlighting

let g:is_posix=1                "syntax highlight shell scripts as per POSIX, not the original Bourne shell

" vim-plug {{{1

" download vim-plug if nonexistent
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
"Plug 'klen/python-mode', { 'for': 'python' }
"Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'bash-support.vim', { 'for': 'sh' }
Plug 'renamer.vim'
Plug 'chriskempson/base16-vim'
Plug 'vim-scripts/vimwiki'
Plug 'AndrewRadev/id3.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'junegunn/fzf', { 'do': 'yes \| ./install' }

if executable("curl")
    Plug 'mattn/webapi-vim'     " dependency of gist-vim
    Plug 'mattn/gist-vim'
endif

filetype plugin indent on	" use file type based plugins and indentation
call plug#end()

" {{{1 look
if &diff
    colorscheme zenburn-rcn
else
    let base16colorspace=256    " Access colors present in 256 colorspace
    colorscheme base16-rcn
endif

set background=dark             " set background to dark or light
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
set visualbell			" set visual bell instead of audio bell
set t_vb=			" no argument means no flash for visual bell
set splitbelow			" put new split windows below
set cmdheight=1			" cmdprompt height
set history=50                  " keep 50 lines of command line history
set laststatus=2		" show status line
set statusline=%F%m%r%h%w\ \|\ format:%{&ff}\ \|\ type:%Y\ \|\ pos:%4l,%4v\ \|\ lines:%L\ \|\ %{fugitive#statusline()}\ %=%3p%%

if has('mouse')
  set mouse=a
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

" {{{1 backup
set backup			" keep a backup file
set backupdir=/tmp		" backup dir
set directory=/tmp		" swap file directory
set backupskip+=*.gpg		" don't save backups of *.gpg files

" {{{1 keymapping
let mapleader=","
set pastetoggle=<F5>		" stop indenting when pasting with the mouse 
inoremap <F6> <C-R>=strftime('%a %d.%m.%Y %H:%M')<CR><CR>

" unmap annoying keys
nnoremap q: <Nop>
nnoremap q/ <Nop>
nnoremap q? <Nop>

" quicker buffer navigation
nnoremap gt :bnext<CR>
nnoremap gT :bprevious<CR>
nnoremap <C-l> :bnext<CR>
nnoremap <C-h> :bprevious<CR>

" To open a new empty buffer
nnoremap <C-n> :enew<CR>

" Make Y behave like other capitals
nnoremap Y y$

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" Close the current buffer and move to the previous one
map <leader>q :bp <BAR> bd #<CR><CR>

" fuzzy search edited files history
map <silent> <leader>h y:call fzf#run({ 'source': v:oldfiles, 'sink' : 'e ', 'options' : '-m', 'down' : '12', })<CR>

" fuzzy search lines in all open buffers
nnoremap <silent> <Leader>l y:call fzf#run({ 'source': <sid>buffer_lines(), 'sink': function('<sid>line_handler'), 'options': '--extended --nth=3..', 'down': '12', })<CR>

" vimdiff keybinds
nmap <F7> [czz			" jump to previous diff code
nmap <F8> ]czz			" jump to next diff code

" convert to lowercase, uppercase, camelcase in visual mode
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

" invoke fzf
nnoremap <silent> <Leader><Leader> :FZF -m<CR>

" vim-commentary
vmap gc  <Plug>Commentary
nmap gcc <Plug>CommentaryLine

" {{{1 functions
" cycle through lowercase/uppercase/camelcase in visual mode
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

" fuzzy search lines in all open buffers
function! s:line_handler(l)
  let keys = split(a:l, ':\t')
  exec 'buf' keys[0]
  exec keys[1]
  normal! ^zz
endfunction

function! s:buffer_lines()
  let res = []
  for b in filter(range(1, bufnr('$')), 'buflisted(v:val)')
    call extend(res, map(getbufline(b,0,"$"), 'b . ":\t" . (v:key + 1) . ":\t" . v:val '))
  endfor
  return res
endfunction

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
    " source vimrc right after saving the buffer
    au BufWritePost ~/.vimrc source %

    " filetype detection for vimperator files
    augroup filetypedetect
        au BufNewFile,BufRead *vimperatorrc*,*muttatorrc*,*.vimp    set filetype=vimperator
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
" {{{2 gist
let g:gist_clip_command='xclip -selection clipboard'
let g:gist_browser_command = 'firefox %URL% &'

" {{{2 airline
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1
let g:airline_mode_map = {'c': 'COMMAND', '^S': 'S-BLOCK', 'R': 'REPLACE', 's': 'SELECT', 'V': 'V-LINE', '^V': 'V-BLOCK', 'i': 'INSERT', '__': '------', 'S': 'S-LINE', 'v': 'VISUAL', 'n': 'NORMAL'}
let g:airline_symbols = {'linenr': '', 'paste': 'PASTE', 'readonly': '', 'modified': '+', 'space': ' ', 'whitespace': '✹', 'branch': ''}
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

" {{{2 vimwiki
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.path_html = '~/vimwiki_html/'
let wiki.auto_export = 1
let wiki.force = 1
let wiki.syntax = 'markdown'
let wiki.ext = '.wiki'
let wiki.css_file = '~/vimwiki_html/style.css'
let wiki.custom_wiki2html = '~/vimwiki/md2html/md2html.py'
let wiki.template_path = '~/vimwiki/templates/'
let wiki.template_default = 'default'
let wiki.template_ext = '.html'
let wiki.nested_syntaxes = {'python': 'python', 'bash': 'sh'}
let g:vimwiki_list = [wiki]

" {{{2 fzf
let g:fzf_height = 12
let g:fzf_action = {
  \ 'ctrl-e': 'e',
  \ 'ctrl-t': 'tabedit',
  \ 'ctrl-h':  'vertical topleft split',
  \ 'ctrl-l':  'vertical botright split' }
