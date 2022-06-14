call plug#begin('~/.vim/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" start: for telesocpe
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" end: for telesocpe
" start: iawriter
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'reedes/vim-colors-pencil'
Plug 'subnut/vim-iawriter'
" end: iawriter
" start: for old vim
Plug 'thoughtbot/vim-rspec'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'
Plug 'fxn/vim-monochrome'
Plug 'ngmy/vim-rubocop'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-rails'
Plug 'rking/ag.vim'
" end: for old vim
call plug#end()

lua require("lsp")

" for nvim-compe
set completeopt=menuone,noselect


"--------------------------------------
" old config
"--------------------------------------

" enable setting title
set title
set wildignore=.o,.obj,.git,Godeps/**,node_modules/**,tmp/**

set cc=80   " Highlight column 80
set number  " show number lines
set mouse=a " use the mouse luke
let mapleader = ","
let g:mapleader = "," " New Leader

" Indentation
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287

" Aliases
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" ruby
augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType * set ai sw=2 sts=2 et
  autocmd BufRead,BufNewFile *_test.rb let b:dispatch = 'bundle exec ruby -Itest %'
  autocmd BufRead,BufNewFile *_spec.rb let b:dispatch = 'bundle exec rspec %'
augroup END

let g:rspec_command = "Dispatch bundle exec rspec {spec}"
autocmd FileType ruby nmap <Leader>t :call RunCurrentSpecFile()<CR>
autocmd FileType ruby nmap <Leader>r :call Rubocop()<CR>
autocmd FileType ruby nmap <Leader>s :call RunNearestSpec()<CR>
autocmd FileType ruby nmap <Leader>l :call RunLastSpec()<CR>
autocmd FileType ruby nmap <Leader>a :call RunAllSpecs()<CR>

" GO
" Run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" Map keys for most used commands.
" Ex: `\b` for building, `\r` for running and `\b` for running test.
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" Gist
let g:gist_clip_command = 'pbcopy'
let g:gist_open_browser_after_post = 1

" Disable Ex mode
map Q <Nop>

" Disable K looking stuff up
map K <Nop>

" Remap save caps to uncaps
command! Q q " Bind :Q to :q
command! E e
command! W w
command! Wq wq

function! <SID>StripTrailingWhitespaces()
  if &ft =~ 'markdown'
    return
  endif
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" Move stuff with arrows
nmap <Left> <<
nmap <Right> >>
vmap <Left> <gv
vmap <Right> >gv
nmap <Up> [e
nmap <Down> ]e
vmap <Up> [egv
vmap <Down> ]egv

" Go to previous file
nnoremap <leader><leader> <c-^>

" Tab completion
set wildmode=list:longest,list:full
set complete=.,w,t
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
