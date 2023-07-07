
" {{{ --------------- basics --------------- 

" reference: https://www.freecodecamp.org/news/vimrc-configuration-guide-customize-your-vim-editor/

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
" set cursorline

" Highlight cursor line underneath the cursor vertically.
" set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
" set expandtab

" Do not save backup files.
" set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=5

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set wrap
set nowrap


" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=50

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

set autoindent
set mouse=a
set title 
set titlestring=vim:%<%F%=%l/%L-%P
set splitbelow
set splitright
let mapleader=' '
colorscheme slate

" }}}

" {{{ --------------- folding  --------------- 

augroup filetype_html_php 
	autocmd!
	autocmd FileType html,php setlocal foldmethod=indent
augroup END

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

set foldmethod=syntax
set foldnestmax=2
set nofoldenable
" set foldclose=all
" set foldlevelstart=1

let javaScript_fold=1         " JavaScript
" let perl_fold=1               " Perl
" let php_folding=1             " PHP
" let r_syntax_folding=1        " R
" let ruby_fold=1               " Ruby
" let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
" let html_folding=1      
" let xml_syntax_folding=1      " XML


" }}}

" {{{ --------------- fuzzy finding --------------- 

" reference: https://dev.to/pbnj/interactive-fuzzy-finding-in-vim-without-plugins-4kkj

function! FZF() abort
	let l:tempname = tempname()

	if system('git rev-parse --is-inside-work-tree') =~ '^true$'
		execute 'silent !git ls-files --cached --other --exclude-standard | fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
	else
		" fzf | awk '{ print $1":1:0" }' > file
		execute 'silent !find . -type f -print | cut -d/ -f2- | fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
		" execute 'silent !fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
		" execute 'silent !git grep . | fzf --multi ' . '| awk ''{ print $1":1:0" }'' > ' . fnameescape(l:tempname)
	endif

	try
		execute 'cfile ' . l:tempname
		redraw!
	finally
		call delete(l:tempname)
	endtry
endfunction

" :Files
command! -nargs=* Files call FZF()

" \ff
nnoremap <leader>ff :Files<cr>

function! RG(args) abort
	let l:tempname = tempname()
	let l:pattern = '.'
	if len(a:args) > 0
		let l:pattern = a:args
	endif
	" rg --vimgrep <pattern> | fzf -m > file
	execute 'silent !rg --vimgrep ''' . l:pattern . ''' | fzf -m > ' . fnameescape(l:tempname)
	try
		execute 'cfile ' . l:tempname
		redraw!
	finally
		call delete(l:tempname)
	endtry
endfunction

" :Rg [pattern]
command! -nargs=* Rg call RG(<q-args>)

" \fs
nnoremap <leader>fs :Rg<cr>

" }}}

" {{{ --------------- mappings --------------- 

" Switch between buffers
nnoremap <leader>jj :bnext<CR>
nnoremap <leader>kk :bprevious<CR>

" Close current buffer
nnoremap <leader>c :bd<CR>
nnoremap <leader>qq :bd!<CR>

nnoremap <leader>s :w<CR>

" Split window horizontally and open a new buffer
nnoremap <leader>h :split<CR>:enew<CR>

" Split window vertically and open a new buffer
nnoremap <leader>v :vsplit<CR>:enew<CR>

" Resize splits
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
inoremap jj <esc>

nnoremap <leader>\ :nohlsearch<CR>

" Press the space bar to type the : character in command mode.
nnoremap <space><space> :

" Press \\ to jump back to the last cursor position.
" nnoremap <leader>\ ``

" Pressing the letter o will open a new line below the current one.
" Exit insert mode after creating a new line above or below the current line.
nnoremap o o<esc>
nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line.
nnoremap Y y$

" }}}

" {{{ --------------- status line --------------- 
" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2


" }}}

" {{{ --------------- netrw --------------- 

" Open the file explorer
nnoremap <leader>e :Explore<CR>

" }}}

" {{{ --------------- fuzzy finding --------------- 



" }}}
