" Enable Pathogen (https://github.com/tpope/vim-pathogen)
execute pathogen#infect()

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim/
set laststatus=2

""""""""""""""""""
" GLOBAL TOGGLES "
""""""""""""""""""

" Enable line numbers and auto-indent
set nu
set ai

" Make backspace work as expected
set backspace=2

" Use 4-space tabs by default
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4

" Persist undo
set undofile
set undodir=$HOME/.vimundo/

" Turn the 'g' flag for :%s on by default
set gdefault

" Highlight search terms
set hlsearch

set ruler

""""""""""""""""""""""""""
" MISCELLANEOUS SETTINGS "
""""""""""""""""""""""""""

command! -nargs=0 Make
            \ | execute ':silent !make'
            \ | execute ':redraw!'

" Keymappings
let mapleader=","
inoremap kk <Esc><Right>
inoremap jj <Esc><Right>
inoremap hh <Esc><Right>
nnoremap <leader>m :w<CR> :Make<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>z :set spell!<CR>
map <leader>b :RainbowParenthesesToggle<CR>
map <leader>f :FixWhitespace<CR>
map <leader>g :GitGutterToggle<CR>
map <leader>h :set hlsearch!<CR>
map <leader>l :set nu!<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>p :set paste!<CR>

" Auto-complete shortcut -> phrase
iabbrev sout System.out.println();<Left><Left>

" Restore cursor upon re-opening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Close Vim if NERDTree is the only window left open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

""""""""""""""""""""""""""""""
" LANGUAGE-SPECIFIC SETTINGS "
""""""""""""""""""""""""""""""

" Git commit message police
autocmd FileType gitcommit setlocal spell textwidth=72

" Python textwidth
autocmd FileType python set textwidth=79

" Use actual tabs in C
autocmd FileType c set noexpandtab

" Go
autocmd FileType go set noexpandtab
autocmd FileType go set textwidth=100
if exists("g:did_load_filetypes")
    filetype off
    filetype plugin indent off
endif
set runtimepath+=/usr/local/go/misc/vim
set runtimepath+=$GOPATH/src/github.com/golang/lint/misc/vim
filetype plugin indent on
syntax on

" Ruby
autocmd FileType ruby set omnifunc=syntaxcomplete#Complete
autocmd FileType ruby set tabstop=2
autocmd FileType ruby set shiftwidth=2
autocmd FileType ruby set softtabstop=2

" Clojure (overtone)
autocmd FileType clojure RainbowParenthesesToggle

" Web
autocmd FileType html set tabstop=4
autocmd FileType html set shiftwidth=4
autocmd FileType html set softtabstop=4
autocmd FileType css set tabstop=4
autocmd FileType css set shiftwidth=4
autocmd FileType css set softtabstop=4
autocmd FileType scss set tabstop=4
autocmd FileType scss set shiftwidth=4
autocmd FileType scss set softtabstop=4
autocmd FileType javascript set textwidth=80
autocmd FileType javascript set tabstop=4
autocmd FileType javascript set shiftwidth=4
autocmd FileType javascript set softtabstop=4
autocmd FileType xml set tabstop=4
autocmd FileType xml set shiftwidth=4
autocmd FileType xml set softtabstop=4

" Markdown
autocmd FileType markdown set textwidth=80

" LaTeX
autocmd FileType tex set textwidth=80
autocmd FileType tex set spell

"""""""""""
" PLUGINS "
"""""""""""

" GitGutter
highlight clear SignColumn
highlight GitGutterAdd ctermfg=40 cterm=bold
highlight GitGutterChange ctermfg=178 cterm=bold
highlight GitGutterDelete ctermfg=124 cterm=bold

" NERDCommenter
let NERDSpaceDelims=1
map <leader>. <plug>NERDCommenterInvert
map <leader>/ <plug>NERDCommenterSexy

""""""""""""""""
" COLORSCHEMES "
""""""""""""""""

colorscheme lunarized
