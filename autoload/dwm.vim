
function! dwm#init()
    if has('autocmd')
        augroup dwm
            autocmd!
            autocmd VimEnter *
                \ autocmd BufWinEnter * if &l:buflisted || &l:filetype == 'help' | call dwm#layout() | endif
        augroup end
    endif
endfunction

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
function! dwm#stack_master(to_top)
    1wincmd w
    if a:to_top
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
function! dwm#new_window()
  call dwm#stack_master(1)
  vert topleft new
  call dwm#resize_pane_width()
endfunction

"
" Move the current window to the master pane (assuming that the previous master
" window is added to the top of the stack from DWM#StackMaster()). If current
" window is master already, the stack top is elected to be swapped with the
" master pane.
"
function! dwm#focus_window()
    if winnr('$') == 1
        return
    endif

    if winnr() == 1
        wincmd w
    endif

    let l:curwin = winnr()
    call dwm#stack_master(1)
    exec l:curwin . "wincmd w"
    wincmd H
    call dwm#resize_pane_width()
endfunction

"
" Redraws the window layout, which is used by the BufWinEnter autocommand
" whenever a new window was added.
"
function! dwm#layout()
    if winnr('$') == 1 || !len(&l:filetype) || &l:buftype == 'quickfix'
        return
    endif

    " Mark: move new window to stack top
    wincmd K

    " Mark: refocus new window
    call dwm#focus_window()
    call dwm#focus_window()
endfunction

"
" Exits the current window, and if it were to be the master pane, it also
" redraws the layout. In that case, the top of the stack pane will take the
" position of the master pane.
"
function! dwm#close_window()
    if winnr() == 1
        " Mark: close the master panel
        close | wincmd H | call dwm#resize_pane_width()
    else
        close
    end
endfunction

"
" Adjusts the split between the master and stack panes by changing the width
" of the master pane. If 'g:dwm_master_pane_width' is defined, the panes will
" be resized accordingly, otherwise it will be a 50% split.
"
function! dwm#resize_pane_width()
    " Mark: all windows equally tall and wide
    wincmd =

    " Mark: resize the master pane if the user defined it
    if exists('g:dwm_master_pane_width')
        if type(g:dwm_master_pane_width) == type("")
            exec 'vertical resize ' . ((str2nr(g:dwm_master_pane_width) * &columns) / 100)
        else
            exec 'vertical resize ' . g:dwm_master_pane_width
        endif
    endif
endfunction

"
" Increases or decreased the width of the barrier between the master and stack
" panes in regards to the offset from the master pane.
"
function! dwm#resize_master(offset)
    let s:master_offset = a:offset * ((winnr() == 1) ? 1 : -1)
    exec 'vertical resize ' . (s:master_offset > 0 ? '+' : '') . s:master_offset

    if exists('g:dwm_master_pane_width') && g:dwm_master_pane_width
        let g:dwm_master_pane_width += s:master_offset
    else
        let g:dwm_master_pane_width = ((&columns) / 2) + 1
    endif
endfunction

"
" Transforms the position of the windows by moving them either clockwise or
" counter-clockwise depending on the input argument. Either the top or bottom
" panel of the stack will take the position of the master pane.
"
function! dwm#rotate(clockwise)
    call dwm#stack_master(a:clockwise)
    if a:clockwise
        wincmd W
    else
        wincmd w
    endif

    wincmd H
    call dwm#resize_pane_width()
endfunction
