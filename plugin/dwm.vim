
"==============================================================================
"    Copyright: Copyright (C) 2012 Stanislas Polu an other Contributors
"               Permission is hereby granted to use and distribute this code,
"               with or without modifications, provided that this copyright
"               notice is copied with it. Like anything else that's free,
"               dwm.vim is provided *as is* and comes with no warranty of
"               any kind, either expressed or implied. In no event will the
"               copyright holder be liable for any damages resulting from
"               the use of this software.
" Name Of File: dwm.vim
"  Description: Dynamic Window Manager behaviour for Vim
"   Maintainer: Joey Smalen (QSmally, Smally) <github@qbot.eu>
" Last Changed: Monday, 8 August 2023
"      Version: 0.2.0 (fork)
"        Usage: This file should reside in the plugin directory and be
"               automatically sourced. For more help, see supplied
"               documentation.
"      History: See supplied documentation.
"==============================================================================

if exists("g:loaded_dwm") || &diff || &cp || v:version < 700
    finish
endif

let g:loaded_dwm = 1

"
" All layout transformations assume the layout contains one master pane on the
" left and an arbitrary number of stacked panes on the right. The function
" DWM#FixWindowLayout() transforms a wrongly-put window layout to the fixed
" margins depending on their winnr's.
"
" +--------+--------+
" |        |   S1   |
" |        +--------+
" |   M    |   S3   |
" |        +--------+
" |        |   S3   |
" +--------+--------+
"

"
" Transitions the current master pane to either the top or bottom of the stack
" pane. At the end, the layout should be the following with the master pane
" being at the top or bottom.
"
" +-----------------+
" |        M        |
" +-----------------+
" |        S1       |
" +-----------------+
" |        S2       |
" +-----------------+
" |        S3       |
" +-----------------+
"
function! DWM#StackMaster(top)
    1wincmd w
    if a:top
        wincmd K
    else
        wincmd J
    endif
endfunction

"
" Empty buffer viewport added as the new master pane, moving the old master
" pane to the top of the stack pane.
"
" TODO: Accept filename to populate window with buffer contents
"
function! DWM#NewWindow()
  call DWM#StackMaster(1)
  vert topleft new
  call DWM#ResizeMasterPaneWidth()
endfunction

"
" Move the current window to the master pane (assuming that the previous master
" window is added to the top of the stack from DWM#StackMaster()). If current
" window is master already, the stack top is elected to be swapped with the
" master pane.
"
function! DWM#FocusWindow()
    if winnr('$') == 1
        return
    endif

    if winnr() == 1
        wincmd w
    endif

    let l:curwin = winnr()
    call DWM#StackMaster(1)
    exec l:curwin . "wincmd w"
    wincmd H
    call DWM#ResizeMasterPaneWidth()
endfunction

"
" Redraws the window layout, which is used by the BufWinEnter autocommand
" whenever a new window was added.
"
function! DWM#FixWindowLayout()
  if winnr('$') == 1 || !len(&l:filetype) || &l:buftype == 'quickfix'
    return
  endif

  " Mark: move new window to stack top
  wincmd K

  " Mark: refocus new window
  call DWM#FocusWindow()
  call DWM#FocusWindow()
endfunction

"
" Exits the current window, and if it were to be the master pane, it also
" redraws the layout. In that case, the top of the stack pane will take the
" position of the master pane.
"
function! DWM#CloseWindowCommand()
    if winnr() == 1
        " Mark: close the master panel
        return 'close | wincmd H | call DWM#ResizeMasterPaneWidth()'
    else
        return 'close'
    end
endfunction

"
" Adjusts the split between the master and stack panes by changing the width
" of the master pane. If 'g:dwm_master_pane_width' is defined, the panes will
" be resized accordingly, otherwise it will be a 50% split.
"
function! DWM#ResizeMasterPaneWidth()
  " Mark: all windows equally tall and wide
  wincmd =

  " Mark: resize the master pane if the user defined it
  if exists('g:dwm_master_pane_width')
    if type(g:dwm_master_pane_width) == type("")
      exec 'vertical resize ' . ((str2nr(g:dwm_master_pane_width)*&columns)/100)
    else
      exec 'vertical resize ' . g:dwm_master_pane_width
    endif
  endif
endfunction

"
" Increases the width of the master pane.
"
" TODO: Combine grow and shrink into one argumented function
"
function! DWM#GrowMaster()
    if winnr() == 1
        exec "vertical resize +1"
    else
        exec "vertical resize -1"
    endif

    if exists("g:dwm_master_pane_width") && g:dwm_master_pane_width
        let g:dwm_master_pane_width += 1
    else
        let g:dwm_master_pane_width = ((&columns)/2)+1
    endif
endfunction

"
" Decreases the width of the master pane.
"
function! DWM#ShrinkMaster()
    if winnr() == 1
        exec "vertical resize -1"
    else
        exec "vertical resize +1"
    endif

    if exists("g:dwm_master_pane_width") && g:dwm_master_pane_width
        let g:dwm_master_pane_width -= 1
    else
        let g:dwm_master_pane_width = ((&columns)/2)-1
    endif
endfunction

"
" Transforms the position of the windows by moving them either clockwise or
" counter-clockwise depending on the input argument. Either the top or bottom
" panel of the stack will take the position of the master pane.
"
function! DWM#Rotate(clockwise)
    call DWM#StackMaster(a:clockwise)
    if a:clockwise
        wincmd W
    else
        wincmd w
    endif

    wincmd H
    call DWM#ResizeMasterPaneWidth()
endfunction

nnoremap <silent> <Plug>DWM#RotateCounterClockwise :call DWM#Rotate(0)<CR>
nnoremap <silent> <Plug>DWM#RotateClockwise        :call DWM#Rotate(1)<CR>
nnoremap <silent> <Plug>DWM#New                    :call DWM#NewWindow()<CR>
nnoremap <silent> <Plug>DWM#Close                  :exec DWM#CloseWindowCommand()<CR>
nnoremap <silent> <Plug>DWM#Focus                  :call DWM#FocusWindow()<CR>
nnoremap <silent> <Plug>DWM#GrowMaster             :call DWM#GrowMaster()<CR>
nnoremap <silent> <Plug>DWM#ShrinkMaster           :call DWM#ShrinkMaster()<CR>

if !exists('g:dwm_map_keys')
    let g:dwm_map_keys = 1
endif

if g:dwm_map_keys
    nnoremap <C-J> <C-W>w
    nnoremap <C-K> <C-W>W

    if !hasmapto('<Plug>DWM#RotateCounterClockwise')
        nmap <C-<> <Plug>DWM#RotateCounterClockwise
    endif
    if !hasmapto('<Plug>DWM#RotateClockwise')
        nmap <C->> <Plug>DWM#RotateClockwise
    endif

    if !hasmapto('<Plug>DWM#New')
        nmap <C-N> <Plug>DWM#New
    endif
    if !hasmapto('<Plug>DWM#Close')
        nmap <C-C> <Plug>DWM#Close
    endif
    if !hasmapto('<Plug>DWM#Focus')
        nmap <C-@> <Plug>DWM#Focus
        nmap <C-Space> <Plug>DWM#Focus
    endif

    if !hasmapto('<Plug>DWM#GrowMaster')
        nmap <C-L> <Plug>DWM#GrowMaster
    endif
    if !hasmapto('<Plug>DWM#ShrinkMaster')
        nmap <C-H> <Plug>DWM#ShrinkMaster
    endif
endif

function! DWM#Init()
    augroup dwm
        autocmd!
        autocmd BufWinEnter * if &l:buflisted || &l:filetype == 'help' | call DWM#FixWindowLayout() | endif
    augroup end
endfunction

if has('autocmd')
    autocmd VimEnter * call DWM#Init()
endif
