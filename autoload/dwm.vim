
"
" Automatic adjusting layout at startup-time (for 'vim -o ...') as well as
" after loading windows from a session.
"
function! dwm#init()
    call dwm#auto_layout()
    autocmd BufWinEnter * call dwm#auto_layout()
endfunction

function dwm#auto_layout()
    if &columns < g:dwm_enable_width || !len(&l:filetype)
        return
    endif

    if winnr('$') == 1 || &l:buftype == 'quickfix' || win_gettype(0) == 'popup'
        return
    endif

    if !&l:buflisted && &l:filetype != 'help'
        return
    endif

    call dwm#layout()
endfunction

"
" For correctly rendering the QuickFix window in the layout, DWM closes and
" reopens the viewport when it's found before adjusting the layout. Its goal
" is to always render QuickFix in its default position on screen.
"
" +--------------+------------------+
" |              |        S1        |
" |              | ---------------- |
" |      M       |        S2        |
" |              | ---------------- |
" |              |        S3        |
" + ------------------------------- +
" |             q-f                 |
" +--------------+------------------+
"
function! dwm#is_qf_open()
    for winnr in range(1, winnr('$'))
        if getwinvar(winnr, '&ft') == 'qf' | return 1 | endif
    endfor
    return 0
endfunction

function! dwm#fix_qf_window()
    if dwm#is_qf_open()
        cclose | silent copen
        1wincmd w
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
    call dwm#fix_qf_window()
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
    call dwm#fix_qf_window()
endfunction

"
" Redraws the window layout, which is used by the BufWinEnter autocommand
" whenever a new window was added.
"
function! dwm#layout()
    if winwidth(0) < g:dwm_skip_width || winheight(0) < g:dwm_skip_height
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
    if winnr('$') == 1
        return
    endif

    if winnr() == 1
        " Mark: close the master panel
        quit | wincmd H | call dwm#resize_pane_width()
        call dwm#fix_qf_window()
    else
        quit
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
