" Line numbering and auto-indenting
set nu
set ai

" Tab stuff
set tabstop=4 shiftwidth=4 expandtab  
set shiftwidth=4
set expandtab
set softtabstop=4

" Highlight the last searched term
set hlsearch

" Custom status bar
" set statusline=%F%m%r%h%w\ [%l,%v][%p%%]\ [%L] 
" set laststatus=2

" For GitGutter
highlight clear SignColumn
highlight GitGutterAdd cterm=bold ctermfg=white
highlight GitGutterChange cterm=bold ctermfg=yellow
highlight GitGutterDelete cterm=bold ctermfg=cyan

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
