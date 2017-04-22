set nocompatible                                                        " sanely reset options on vimrc re-source
syntax on                                                               " ensure syntax highllighting is enabled
filetype on                                                             " for syntax highlighting

colorscheme darkblue                                                    " colorscheme
set backspace=2                                                         " make backspace work like most other apps
set hlsearch                                                            " highlist search result
set ruler                                                               " ruler
set showmatch                                                           " highlight matching brackets
set wildmenu                                                            " more easily locate files
set wildmode=list:longest,full                                          " extra results
" let g:clipbrdDefaultReg = '+'                                         " for linux clipboard
set nohidden                                                            " remove buffer no tab close
set showcmd                                                             " shows typing as command
set cursorline                                                          " easily find cursor
set number numberwidth=1                                                " enable numbers
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab             " expand tab to spaces
" set colorcolumn=81                                                    " set colorcolumn for all files
" let &colorcolumn="81,".join(range(120,999),",")                       " additional colourcolumns
highlight colorcolumn ctermbg=4                                         " set colorcolumn colour to blue
autocmd BufEnter *.q set colorcolumn=81                                 " set colorcolumn in q files
autocmd BufEnter *.q let &colorcolumn="81,".join(range(121,999),",")    " additional colourcolumns for q files
" autocmd BufEnter *.py highlight colorcolumn ctermbg=3                 " custom colour for py files
autocmd BufEnter *.py set colorcolumn=81                                " set colorcolumn in py files
" set commentstring=//\ %s  " for q syntax
" :%!xxd                                                                " hex editor
" :%!xxd -r                                                             " revert to normal editor

set foldmethod=marker foldnestmax=10 nofoldenable foldlevel=2           " options for folding markers


"" functions

function! NumberToggle()                                                " function to toggle number behaviour
  if(&relativenumber == 1)
    set norelativenumber
    set nonumber
  elseif(&number == 1)
    set relativenumber
  else
    set number
  endif
endfunc


"" key mapping

nnoremap <C-n> :call NumberToggle()<CR>                                 " map NumberToggle to ctrl+n

nnoremap k gk                                                           " move up by visual line
nnoremap <Up> gk
nnoremap j gj                                                           " move down by visual line
nnoremap <Down> gj


"" auto commands

autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif     " auto remove trailing whitespace

augroup JumpCursorOnEdit                                                " restore cursor position on reopen
   au!
   autocmd BufReadPost *
            \ if expand("<afile>:p:h") !=? $TEMP |
            \   if line("'\"") > 1 && line("'\"") <= line("$") |
            \     let JumpCursorOnEdit_foo = line("'\"") |
            \     let b:doopenfold = 1 |
            \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
            \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
            \        let b:doopenfold = 2 |
            \     endif |
            \     exe JumpCursorOnEdit_foo |
            \   endif |
            \ endif
   " Need to postpone using "zv" until after reading the modelines.
   autocmd BufWinEnter *
            \ if exists("b:doopenfold") |
            \   exe "normal zv" |
            \   if(b:doopenfold > 1) |
            \       exe  "+".1 |
            \   endif |
            \   unlet b:doopenfold |
            \ endif
augroup END
