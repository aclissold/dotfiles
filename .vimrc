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

" Golang plugins
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

" Highlight the last searched term
set hlsearch

" 'g' flag for :%s on by default
set gdefault

" Custom status bar
" set statusline=%F%m%r%h%w\ [%l,%v][%p%%]\ [%L] 
" set laststatus=2

" For GitGutter
highlight clear SignColumn
highlight GitGutterAdd ctermfg=40 cterm=bold
highlight GitGutterChange ctermfg=178 cterm=bold
highlight GitGutterDelete ctermfg=124 cterm=bold

colorscheme symfony_modified

" Smooth scrolling
function SmoothScroll(up)
    if a:up
        let scrollaction=""
    else
        let scrollaction=""
    endif
    exec "normal " . scrollaction
    redraw
    let counter=1
    while counter<&scroll
        let counter+=1
        sleep 10m
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction
nnoremap <C-U> :call SmoothScroll(1)<Enter>
nnoremap <C-D> :call SmoothScroll(0)<Enter>
inoremap <C-U> <Esc>:call SmoothScroll(1)<Enter>i
inoremap <C-D> <Esc>:call SmoothScroll(0)<Enter>i
