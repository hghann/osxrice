" File: .vimrc
" Maintainer: hghann
"  ██▒   █▓ ██▓ ███▄ ▄███▓ ██▀███   ▄████▄
" ▓██░   █▒▓██▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▒██▀ ▀█
"  ▓██  █▒░▒██▒▓██    ▓██░▓██ ░▄█ ▒▒▓█    ▄
"   ▒██ █░░░██░▒██    ▒██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒
"    ▒▀█░  ░██░▒██▒   ░██▒░██▓ ▒██▒▒ ▓███▀ ░
"    ░ ▐░  ░▓  ░ ▒░   ░  ░░ ▒▓ ░▒▓░░ ░▒ ▒  ░
"    ░ ░░   ▒ ░░  ░      ░  ░▒ ░ ▒░  ░  ▒
"      ░░   ▒ ░░      ░     ░░   ░ ░
"       ░   ░         ░      ░     ░ ░
"      ░                           ░
" Set fold method immediately
"set foldmethod=marker

" Quick Init: {{{1
if has('nvim')
	set runtimepath^=~/.vim runtimepath+=~/.vim/after
endif

" block plugins and extra dependency's
let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

" Disable extra built-in plugins for speed
let g:loaded_gzip               =  1
let g:loaded_tarPlugin          =  1
let g:loaded_zipPlugin          =  1
let g:loaded_2html_plugin       =  1
"don't use any remote plugins so no need to load them
let g:loaded_rrhelper           =  1
let g:loaded_remote_plugins     =  1
let g:loaded_netrw              =  1
let g:loaded_netrwPlugin        =  1

" Automate remove trailing whitespace on save and prevent cursor teleport
augroup TRIM_WHITESPACE
    autocmd!
    autocmd BufWritePre * let w:save = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(w:save)
augroup END
" }}}

" Plugin Management: {{{1
" Install vim-plug if it's not already present
augroup PLUGGED
	autocmd!
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fo ~/.vim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
augroup end

call plug#begin('~/.vim/plugged')
    Plug 'Gavinok/vim-troff'    " Gavinok's troff/groff plugin
    Plug 'Gavinok/spaceway.vim' " Gavinok's spaceway colorscheme
call plug#end()
" }}}

" General Settings: {{{1
set nocompatible                " Use Vim defaults instead of original Vi
" Core logic {{{2
" Enable Filetypes, Syntax, and Folding
filetype plugin indent on       " Enable filetype-specific plugins and indent rules
syntax enable                   " Enable syntax highlighting
set foldmethod=syntax           " Global default: use syntax to determine folds
"set foldlevelstart=99           " Start with all folds open
"2}}} "Core logic
" Interaction settings {{{2
set mouse=a                     " Enable mouse support
set clipboard=unnamedplus       " Sync with system clipboard
set backspace=indent,eol,start  " Allow backspacing over everything
let mapleader = " "
set spelllang=en_us             " Set language globally (disabled by default)
" 2}}} "Interaction settings
" Visuals {{{2
if (has("termguicolors"))
  set termguicolors
endif
colorscheme spaceway
" 2}}} "Visuals
" 1}}} "General Settings

" UI and Navigation: {{{1
set number                      " Show absolute line number
set relativenumber              " Show relative numbers (Hybrid Mode)
set showcmd                     " Show incomplete commands in status line
set wildmenu                    " Enhanced command-line completion
set scrolloff=8                 " Keep 8 lines visible above/below cursor
set colorcolumn=80              " Draw a vertical line at column 80
set cursorline                  " Highlight the current horizontal line
set cursorcolumn                " Highlight the current vertical column
set guicursor=n-v-c-i:block     " Force a block cursor in all modes
" }}}

" Search Settings: {{{1
set incsearch                   " Highlight matches as you type
set hlsearch                    " Highlight all search matches
set ignorecase                  " Ignore case when searching
set smartcase                   " Override ignorecase if search has capitals
" }}}

" Indentation and Tabs: {{{1
set tabstop=4                   " A tab is 4 spaces wide
set shiftwidth=4                " Indents are 4 spaces wide
set expandtab                   " Use spaces instead of tabs
set autoindent                  " Copy indent from previous line
" }}}

" Keyboard Shortcuts: {{{1
" Make 'c' perform a yank (copy) instead of change
nnoremap c y
vnoremap c y

" Map 'cc' to yank the entire current line
nnoremap cc yy

" Search for the visually selected text forward (maps '*' to visual selection search)
vnoremap * "vy/<C-r>v<CR>

" Reload .vimrc quickly with Leader + r
nnoremap <leader>r :source $MYVIMRC<CR>

" Toggle Crosshairs (Leader + h)
nnoremap <leader>h :set cursorline! cursorcolumn!<CR>

" Toggle vertical margin line at column 80 (Leader + l)
nnoremap <leader>l :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>

" Toggle spell check manually when needed
nnoremap <silent> <leader>s :setlocal spell!<CR>

" Searchable keymaps in bottom split + press 'q' to close
" only shows entries starting with your current mapleader
nnoremap <silent> <leader>m :botright 15new <Bar>
    \ setlocal buftype=nofile <Bar>
    \ silent redir @a <Bar>
    \ execute 'silent filter /^' . escape(get(g:, 'mapleader', '\'), '\') . '/ map' <Bar>
    \ silent redir END <Bar>
    \ silent put a <Bar>
    \ 1delete _ <Bar>
    \ nnoremap <buffer> q :q!<CR>

" shows all entries
"nnoremap <silent> <leader>m :botright 15new <Bar>
    \ setlocal buftype=nofile <Bar>
    \ silent redir @a <Bar>
    \ silent map <Bar>
    \ silent redir END <Bar>
    \ silent put a <Bar> 1delete _ <Bar>
    \ nnoremap <buffer> q :q!<CR>

" Use Leader + Space to toggle the current fold
nnoremap <leader><space> za

" Toggle ALL folds globally with Leader + o
nnoremap <leader>o zi

" delete matches
nmap dm :%s/<c-r>///g<CR>

" change matches
nmap cm :%s/<c-r>///g<Left><Left>

" Fix common 'Shift' key typos for saving and exiting
command! Wq wq
command! Wwq wq
command! WQ wq
command! W w
command! Q q

" Automatically correct 'wwq' typo to 'wq'
cnoreabbrev wwq wq
cnoreabbrev ww w
" }}}

" Line Wrapping: {{{1
" Soft Wrap (visual only, doesn't change file)
set wrap                " Enable line wrapping
set linebreak           " Wrap at words, not in the middle of a word
set breakindent         " Wrapped lines maintain the same indent level

" Navigation for wrapped lines
" Makes 'j', 'k', and Arrows move by visual lines instead of logical lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk

" Fix movement in Insert Mode for the arrow keys
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk

" Toggle soft wrap manually (Leader + w)
nnoremap <leader>w :set wrap! linebreak!<CR>

" Hard Wrap (inserts actual newlines)
set textwidth=0         " Disable hard wrapping by default
set formatoptions+=t    " Auto-wrap text using textwidth
" }}}

" Prose Settings: {{{1
" Automatically enable spell check ONLY for text-heavy files
augroup SPELL_CHECK
    autocmd!
    autocmd FileType markdown,gitcommit,text,groff,tex,mail,yaml setlocal spell
augroup END
" }}}

" Wayland Clipboard Fix: {{{1
if has('wayland') || !empty($WAYLAND_DISPLAY)
    let g:clipboard = {
          \   'name': 'wl-clipboard',
          \   'copy': {
          \      '+': ['wl-copy', '--type', 'text/plain'],
          \      '*': ['wl-copy', '--type', 'text/plain', '--primary'],
          \    },
          \   'paste': {
          \      '+': ['wl-paste', '--no-newline', '--type', 'text/plain'],
          \      '*': ['wl-paste', '--no-newline', '--type', 'text/plain', '--primary'],
          \   },
          \   'cache_enabled': 1,
          \ }
endif
" }}}

" Groff Settings: {{{1
" --- Filetype Detection ---
augroup groff_detection
    autocmd!
    autocmd BufNewFile,BufRead *.ms,*.mom,*.me,*.mm,*.tr,*.troff set filetype=groff
augroup END

augroup groff_settings
    autocmd!
    " Compile Groff to PDF (Space + c)
    autocmd FileType groff nnoremap <buffer> <leader>c :w<CR>:!groff -ms % -T pdf > %:r.pdf<CR><CR>
augroup END
" }}}

" Aesthetics: {{{1 "
" colorscheme acme
colorscheme spaceway
highlight Normal ctermbg=NONE
highlight Conceal ctermbg=NONE

" Force color for the vertical colorcolumn bar (e.g., light gray)
"highlight ColorColumn ctermbg=252 guibg=#D3D3D3

" Reset any default underlining and match crosshair colors
highlight clear CursorLine
highlight link CursorLine CursorColumn

function! Statusline_expr()
	let mod  = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
	let ft   = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
	let fug  = "%3*%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
	let job  = "%2*%{exists('g:job') ? '[Job Running!]' : ''}%*"
	let zoom = "%3*%{exists('t:maximize_hidden_save') ? '[Z]' : ''}%*"
	let sep  = ' %= '
	let pos  = ' %-14.(%l,%c%V%) '
	let pct  = ' %P'

	return '%<%f %<'.mod.fug.job.zoom.sep.pos.pct
endfunction
let &statusline = Statusline_expr()
set laststatus=2 "show statusbar

if has('gui_running')
	call dotvim#LoadGui()
elseif exists('g:colors_name') && g:colors_name !=# 'acme'
	hi Normal      guibg=NONE
	hi ColorColumn guibg=NONE
	hi SignColumn  guibg=NONE
	hi Folded      guibg=NONE
	hi Conceal     guibg=NONE
	hi Terminal    guibg=NONE
	hi LineNr      guibg=NONE
endif
" 1}}} Aesthetics "

