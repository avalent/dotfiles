" Leader
let mapleader = ","
let maplocalleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=100
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set nocompatible  " Use Vim defaults instead of 100% vi compatibility

" Use case-smart searching
" These two options, when set together, will make /-style searches
" case-sensitive only if there is a capital letter in the search expression.
" *-style searches continue to be consistently case-sensitive.
set ignorecase
set smartcase

set hlsearch            " highlight the last searched term

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Automatically wrap at 120 characters and set shiftwidth to 4 for Java
  autocmd BufNewFile,BufRead *.java setlocal textwidth=120 shiftwidth=4

  " Automatically wrap at 120 characters for Haskell
  autocmd BufNewFile,BufRead *.hs setlocal textwidth=120

  " Automatically wrap at 140 characters and set shiftwidth to 4 for Python
  autocmd BufNewFile,BufRead *.py setlocal textwidth=140 shiftwidth=4
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Configure CtrlP
let g:ctrlp_extensions = ['tag']
let g:ctrlp_root_markers = ['.ctrlp', '.cabal-sandbox']
nnoremap <C-b> :CtrlPBuffer<CR>
nnoremap <C-m> :CtrlPMixed<CR>
nnoremap <leader>t :CtrlPTag<CR>
nnoremap <leader>r :CtrlPMRUFiles<CR>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Configure syntastic syntax checking to check on open as well as save
"let g:syntastic_check_on_open=1
"let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" Syntastic is really slow. Put it into passive mode so I have to manually
" execute :SyntasticCheck if I want it to run.
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": ["php"],
    \ "passive_filetypes": ["puppet"] }

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

" Use the solarized dark colour scheme
set background=dark
colorscheme solarized

" Set the paste mode toggle key to F2
set pastetoggle=<F2>

" Airline customisation
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1

" Move to next buffer with Tab and previous buffer with Shift-Tab
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

set clipboard=unnamedplus,unnamed,autoselect

" Toggle nerdtree with <leader>1 (Similar to IntelliJ IDEA file browser)
map <silent> <leader>1 :NERDTreeToggle<CR>

" <Leader>n: NERDTreeFind
nnoremap <silent> <Leader>n :NERDTreeFind<cr> :wincmd p<cr>

"let g:unite_enable_start_insert=1
"nnoremap <space>/ :Unite grep:.<CR>

" Save a file with sudo
cnoremap w!! w !sudo tee %

" Allows :diffget and :diffput on the current line only. Achieves this by
" going into visual mode on the whole line, and then running the command
nnoremap <silent> <leader>dp V:diffput<cr>
nnoremap <silent> <leader>dg V:diffget<cr>

" When using Gdiff we often want to talk from either the left or right panes.
nnoremap <silent> <leader>gl :diffget //2 <cr> :diffupdate<cr>
nnoremap <silent> <leader>gr :diffget //3 <cr> :diffupdate<cr>

" Snippet trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" MacVim settings (we need another test here to see if it is MacVim and not ordinary GVim)
if has('gui_running')
    set transparency=15
    set guifont=Source\ Code\ Pro\ for\ Powerline:h14
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
endif

" Make window split borders look nicer.
set fillchars+=vert:\|
hi! VertSplit guifg=fg guibg=bg
hi! VertSplit ctermfg=fg ctermbg=bg term=NONE

" CtrlP Most Recently Used
nnoremap <silent> <leader>m :CtrlPMRU<CR>

" Uppercase the current word from insert mode
" FIXME For some reason this isn't working
"inoremap <C-u> <ESC>viwUea

" Common identifiers that we may want to align on in Haskell.
let g:haskell_tabular = 1
vmap a, :Tabularize /,<CR>
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
