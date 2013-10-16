" Enable Pathogen (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()

map <F7> :w<cr>:!~/Code/public_html/deploy.sh<cr>:redraw<cr>

""""""""""""""""""""""
" GLOBAL VIM TOGGLES "
""""""""""""""""""""""

" Line numbering and auto-indenting
set nu
set ai

" Tab stuff
set tabstop=4
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

inoremap jj <ESC><Right>
inoremap kk <ESC><Right>
nnoremap ' @

""""""""""""""""""""""""""""""
" LANGUAGE-SPECIFIC SETTINGS "
""""""""""""""""""""""""""""""

" Python textwidth
autocmd FileType python set textwidth=79

" Use actual tabs in C
autocmd FileType c set expandtab!

" Go
autocmd FileType go set expandtab!
autocmd FileType go set textwidth=100
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
set runtimepath+=$GOPATH/src/github.com/golang/lint/misc/vim
filetype plugin indent on
syntax on

" 2-space tabs for certain languages
autocmd FileType html set tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd FileType xml set tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd FileType css set tabstop=2 shiftwidth=2 expandtab softtabstop=2
autocmd FileType jsp set tabstop=2 shiftwidth=2 expandtab softtabstop=2

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
