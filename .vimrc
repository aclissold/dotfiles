" Enable Pathogen (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()

""""""""""""""""""""""
" GLOBAL VIM TOGGLES "
""""""""""""""""""""""

" Line numbering and auto-indenting
set nu
set ai

" Tab stuff
set tabstop=4 shiftwidth=4 expandtab  
set shiftwidth=4
set expandtab
set softtabstop=4

" Dynamic titles
set title
set titleold=Terminal

" Persistent undo
set undofile
set undodir=$HOME/.vimundo/

" 'g' flag for :%s on by default
set gdefault

"""""""""""""""""""
" CUSTOM SETTINGS "
"""""""""""""""""""

" Auto-complete shortcut -> phrase
iabbrev sout System.out.println();<Left><Left>

" Restore cursor upon re-opening a file
" (Note: has a bug where it doesn't save cursor index on top line of file)
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

""""""""""""""""""""""""""""""
" LANGUAGE-SPECIFIC SETTINGS "
"""""""""""""""""""""""""""""" 

" Python textwidth
autocmd FileType python set textwidth=79

" Use tabs in C
autocmd FileType c set expandtab!

" Golang plugins
autocmd FileType go set expandtab!
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
set runtimepath+=$GOPATH/src/github.com/golang/lint/misc/vim
filetype plugin indent on
syntax on

"""""""""""""
" GITGUTTER "
"""""""""""""

highlight clear SignColumn
highlight GitGutterAdd ctermfg=40 cterm=bold
highlight GitGutterChange ctermfg=178 cterm=bold
highlight GitGutterDelete ctermfg=124 cterm=bold

""""""""""""""""
" COLORSCHEMES "
""""""""""""""""

colorscheme symfony_modified
