set nocompatible                                                        " sanely reset options on vimrc re-source
filetype plugin on                                                      " allow loading from ftplugin
syntax on                                                               " ensure syntax highllighting is enabled

colorscheme darkblue                                                    " colorscheme
set backspace=2                                                         " make backspace work like most other apps
set hlsearch                                                            " highlist search result
set incsearch                                                           " highlight searches as they are types
set showmatch                                                           " highlight matching brackets
set wildmenu                                                            " show graphical file menu when autocompleting
set wildmode=list:longest,full                                          " extra results
set nohidden                                                            " remove buffer on tab close
set showcmd                                                             " shows command in bottom bar
set cursorline                                                          " easily find cursor
set lazyredraw                                                          " redraw when necessary
set number numberwidth=1                                                " enable numbers
set tabstop=4                                                           " number of visual spaces per tab
set expandtab                                                           " turn tabs to spaces
set shiftwidth=4                                                        " number of spaces used for indentation
set softtabstop=4                                                       " number of spaces to insert instead of tab
set smarttab
set colorcolumn=97                                                      " set colorcolumn for all files
highlight colorcolumn ctermbg=4
"let g:clipbrdDefaultReg = '+'                                          " for linux clipboard
"let &colorcolumn="81,".join(range(120,999),",")                        " additional colourcolumns
"set colorcolumn colour to blue
":%!xxd                                                                 " hex editor
":%!xxd -r                                                              " revert to normal editor
":retab                                                                 " replaces tabs with spaces according to current settings

set foldmethod=marker foldnestmax=10 nofoldenable foldlevel=2           " options for folding markers


"" functions

" function to toggle number behaviour
function! NumberToggle()
  let save_pos = getpos(".")
  if(&relativenumber == 1)
    set norelativenumber
    set nonumber
  elseif(&number == 1)
    set relativenumber
  else
    set number
  endif
  call setpos('.', save_pos)
endfunc

" fill with spaces up to comment column
function! SpaceToComment( str )
    let tw = &colorcolumn                                               " set tw to the desired comment column
    if tw==0 | let tw = 81 | endif
    " strip trailing spaces first
    .s/[[:space:]]*$//
    " calculate total number of 'str's to insert
    let reps = (tw - col("$")) / len(a:str)
    " insert them, if there's room, removing trailing spaces (though forcing
    " there to be one)
    if reps > 0
        .s/$/\=(' '.repeat(a:str, reps))/
        normal $
    endif
endfunction


"" key mapping

" map NumberToggle
nnoremap <C-n> :call NumberToggle()<CR>

" move up by visual line
nnoremap <Up> gk
" move down by visual line
nnoremap <Down> gj

" map SpaceToComment to ctrl+m
execute "set <M-m>=\em"
nnoremap <M-m> :call SpaceToComment(' ')<CR>


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

"au! BufRead,BufNewFile *.ext setfiletype ext                           " create custom file extension for use with ftplugin

"set paste                                                              " don't retab on paste
set ruler                                                               " show column number in status bar
