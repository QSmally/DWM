
"
" Automatic adjusting layout at startup-time (for 'vim -o ...') as well as
" after loading windows from a session.
"
function! dwm#init()
    call dwm#layout()
    autocmd BufWinEnter * call dwm#auto_layout()
    autocmd VimResized * call dwm#layout()
endfunction

function dwm#auto_layout()
    if winnr('$') == 1 || &l:buftype == 'quickfix' || win_gettype(0) == 'popup' | return | endif
    if !&l:buflisted && &l:filetype != 'help' && !len(&l:filetype) | return | endif
    if &columns < g:dwm_enable_width | return | endif

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
" |      M0      |        S2        |
" |              | ---------------- |
" |              |        S3        |
" +--------------+------------------+
" |      qf                         |
" +---------------------------------+
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
" +----------------+
" |       M0       |
" +----------------+
" |       S1       |
" +----------------+
" |       S2       |
" +----------------+
" |       S3       |
" +----------------+
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
function! dwm#new_window(bang, fname)
    call dwm#stack_master(1)
    exec 'new ' . a:fname
    call dwm#focus_window(0)
    if !a:bang | call dwm#focus_window(0) | endif
endfunction

"
" Move the current window to the master pane (assuming that the previous master
" window is added to the top of the stack from dwm#stack_master()). If current
" window is master already, the stack top is elected to be swapped with the
" master pane.
"
function! dwm#focus_window(win)
    if winnr('$') == 1 || winnr('$') <= a:win
        return
    endif

    if winnr() == 1
        wincmd w
    endif

    let l:curwin = a:win == 0 ? winnr() : a:win + 1
    call dwm#stack_master(1)
    exec l:curwin . 'wincmd w'
    exec 'wincmd ' . (&columns >= g:dwm_enable_width ? 'H' : 'K')

    call dwm#resize_pane_width()
    call dwm#fix_qf_window()
endfunction

"
" Redraws the window layout, which is used by the BufWinEnter autocommand
" whenever a new window was added.
"
function! dwm#layout()
    if winnr('$') == 1 || winwidth(0) < g:dwm_skip_width || winheight(0) < g:dwm_skip_height
        return
    endif

    " Mark: move new window to stack top
    wincmd K

    " Mark: refocus new window
    call dwm#focus_window(0)
    call dwm#focus_window(0)
endfunction

"
" Exits the current window, and if it were to be the master pane, it also
" redraws the layout. In that case, the top of the stack pane will take the
" position of the master pane.
"
function! dwm#close_window(win)
    if winnr('$') == 1 || winnr('$') <= a:win
        return
    endif

    " Mark: close the master panel
    if a:win == 0 && winnr() == 1
        quit
        call dwm#focus_window(0)
        call dwm#focus_window(0)
        return
    endif

    let l:curwin = winnr()
    let l:tarwin = a:win == 0 ? winnr() : a:win + 1
    exec l:tarwin . 'wincmd w' | quit

    let l:fix = l:curwin < l:tarwin ? 0 : -1
    exec l:curwin + l:fix . 'wincmd w'
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
        if type(g:dwm_master_pane_width) == type('')
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

    exec 'wincmd ' . (&columns >= g:dwm_enable_width ? 'H' : 'K')
    call dwm#resize_pane_width()
endfunction
