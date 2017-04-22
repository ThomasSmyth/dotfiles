set nocompatible                                                " sanely rest options when re-sourcing .vimrc
syntax on                                                       " ensure syntax highllighting is enabled

colorscheme darkblue                                            " colorscheme
set backspace=2                                                 " make backspace work like most other apps
set hlsearch                                                    " highlist search result
set ruler                                                       " ruler
set showmatch                                                   " highlight matching brackets
set wildmenu                                                    " more easily locate files
set cursorline                                                  " easily find cursor
set number numberwidth=1                                        " enable numbers at smallest possible width
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab     " expand tab to spaces
" set colorcolumn=81
autocmd BufEnter *.q colorcolumn=81                             " set colorcolumn in q files
autocmd BufEnter *.py colorcolumn=81                            " set colorcolumn in pv files
" set commentstring=//\ %s  " for q syntax
" :%!xxd                                                        " hex editor
" :%!xxd -r                                                     " revert to normal editor

set foldmethod=marker foldnestmax=10 nofoldenable foldlevel=2   " options for folding markers

function! NumberToggle()                                        " function to toggle number behaviour
  if(&relativenumber == 1)
    set norelativenumber
    set nonumber
  elseif(&number == 1)
    set relativenumber
  else
    set number
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<CR>                         " map NumberToggle to ctrl+n

nnoremap k gk                                                   " move up by visual line
nnoremap <Up> gk
nnoremap j gj                                                   " move down by visual line
nnoremap <Down> gj
