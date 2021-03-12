" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Nov 16

set shiftwidth=4

""" FROM https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" VUNDLE: manage plugins for vim
"Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)

" VUNDLE: GENERIC PROGRAMMING SUPPORT
" pydoc: look up python functions with <shift>-K
"Bundle 'fs111/pydoc.vim'
" youcompleteme: tab completion with anything defined in the text before
"Bundle 'Valloric/YouCompleteMe'
" tcomment: g->/< to comment/uncomment code in any language
"Bundle 'tomtom/tcomment_vim'
" nerdtree: sidebar to search filesystem
"Plugin 'scrooloose/nerdtree'
" exuberant-ctags: manage ctags content
"Plugin 'jakedouglas/exuberant-ctags'

"call vundle#end()
filetype plugin indent on

""" Configuration: YouCompleteMe
let g:ycm_python_binary_path='/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_completion=1
" Go to the declaration/definition of a func using '-g'
let mapleader = "-"
map <leader>g : YcmCompleter GoToDefinitionElseDeclaration<CR>

""" Configuration: pydoc.vim
let g:pydoc_cmd="/usr/bin/pydoc3"

""" FROM https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/


""" FROM http://stackoverflow.com/questions/18948491/running-python-code-in-vim
" Press F5 to execute current buffer with python3.
function! SaveAndExecutePython()
    " SOURCE [reusable window]: https://github.com/fatih/vim-go/blob/master/autoload/go/ui.vim

    " save and reload the current file
    silent execute "update | edit"

    " get file path of current file
    let s:current_buffer_file_path = expand("%")

    let s:output_buffer_name = "Python"
    let s:output_buffer_filetype = "output"

    " reuse existing buffer window if it exists otherwise create a new one
    if !exists("s:buf_nr") || !bufexists(s:buf_nr)
        silent execute 'botright new ' . s:output_buffer_name
        let s:buf_nr = bufnr('%')
    elseif bufwinnr(s:buf_nr) == -1
        silent execute 'botright new'
        silent execute s:buf_nr . 'buffer'
    elseif bufwinnr(s:buf_nr) != bufwinnr('%')
        silent execute bufwinnr(s:buf_nr) . 'wincmd w'
    endif

    silent execute "setlocal filetype=" . s:output_buffer_filetype
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal winfixheight
    setlocal cursorline " make it easy to distinguish
    setlocal nonumber
    setlocal norelativenumber
    setlocal showbreak=""

    " clear the buffer
    setlocal noreadonly
    setlocal modifiable
    %delete _

    " add the console output
    silent execute ".!python3 " . shellescape(s:current_buffer_file_path, 1)

    " resize window to content length
    " Note: This is annoying because if you print a lot of lines then your code buffer is forced to a height of one line every time you run this function.
    "       However without this line the buffer starts off as a default size and if you resize the buffer then it keeps that custom size after repeated runs of this function.
    "       But if you close the output buffer then it returns to using the default size when its recreated
    "execute 'resize' . line('$')

    " make the buffer non modifiable
    setlocal readonly
    setlocal nomodifiable
endfunction

nnoremap <silent> <F5> :<C-u>call SaveAndExecutePython()<CR>
""" FROM http://stackoverflow.com/questions/18948491/running-python-code-in-vim


" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"if has("vms")
"	set nobackup		" do not keep a backup file, use versions instead
"else
"	set backup		" keep a backup file
"endif

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set nowrap
"set number
"set incsearch		" do incremental searching

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'






filetype on
augroup vimrc_filetype
	autocmd!
	autocmd FileType tex call s:MyTexSettings()
	autocmd FileType c call s:MyCSettings()
	autocmd FileType cpp call s:MyCSettings()
	autocmd FileType vim call s:MyVimSettings()
	autocmd FileType py call s:MyPySettings()
augroup end

" Clear all comment markers (one rule for all languages)
map _ :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

function! s:MyTexSettings()
	" Insert comments markers
	map - :s/^/%/<CR>:nohlsearch<CR>
endfunction

function! s:MyCSettings()
	" Insert comments markers
	map - :s/^/\/\//<CR>:nohlsearch<CR>
endfunction

function! s:MyVimSettings()
	" Insert comments markers
	map - :s/^/\"/<CR>:nohlsearch<CR>
endfunction

function! s:MyPySettings()
	" Insert comments markers
	map - :s/^/#/<CR>:nohlsearch<CR>
endfunction





set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
set mouse=a
filetype plugin on
set shellslash
set grepprg=grep\ -nH\ $*
set nofoldenable

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

	" Enable file type detection.
	" Use the default filetype settings, so that mail gets 'tw' set to 72,
	" 'cindent' is on in C files, etc.
	" Also load indent files, to automatically do language-dependent indenting.
	filetype plugin indent on

	" Put these in an autocmd group, so that we can delete them easily.
	augroup vimrcEx
	au!

	" For all text files set 'textwidth' to 78 characters.
	autocmd FileType text setlocal textwidth=78

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\	 exe "normal! g`\"" |
		\ endif

	augroup END

else

	set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" Modifier by: Nare Karapetyan, Jan 27 2021 to add netrw settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 15
"the following will allways open sidebar whenever vim is opened
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

autocmd FileType netrw setl bufhidden=delete
