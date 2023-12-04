
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
" Last Changed: Monday, 04 December 2023
"      Version: 0.2.5 (fork)
"        Usage: This file should reside in the plugin directory and be
"               automatically sourced. For more help, see supplied
"               documentation.
"      History: See supplied documentation.
"==============================================================================

if exists('g:loaded_dwm') || &diff || &cp || v:version < 700
    finish
endif

let g:loaded_dwm = 1

"
" All layout transformations assume the layout contains one master pane on the
" left and an arbitrary number of stacked panes on the right. The function
" dwm#layout() transforms a wrongly-put window layout to the fixed margins
" depending on their winnr's.
"
" +--------------+------------------+
" |              |        S1        |
" |              | ---------------- |
" |      M0      |        S2        |
" |              | ---------------- |
" |              |        S3        |
" +--------------+------------------+
"

" Mark: public API
nnoremap <silent> <Plug>(dwm_rotate_right) :WRR<CR>
nnoremap <silent> <Plug>(dwm_rotate_left) :WRL<CR>
nnoremap <silent> <Plug>(dwm_new_window) :New<CR>
nnoremap <silent> <Plug>(dwm_close_window) :Close<CR>
nnoremap <silent> <Plug>(dwm_focus_window) :Switch<CR>
nnoremap <silent> <Plug>(dwm_barrier_right) :WBR<CR>
nnoremap <silent> <Plug>(dwm_barrier_left) :WBL<CR>

" Mark: commands
command! WRR call dwm#rotate(1)
command! WRL call dwm#rotate(0)
command! -nargs=? -complete=file -bang New call dwm#new_window(<bang>0, <q-args>)
command! -count=0 Close call dwm#close_window(v:count == 0 ? <count> : v:count)
command! -count=0 Switch call dwm#focus_window(v:count == 0 ? <count> : v:count)
command! WBR call dwm#resize_master(1)
command! WBL call dwm#resize_master(-1)

" Mark: defaults
if !exists('g:dwm_default_keys')    | let g:dwm_default_keys = 1      | endif
if !exists('g:dwm_enable_width')    | let g:dwm_enable_width = 2 * 81 | endif
if !exists('g:dwm_skip_width')      | let g:dwm_skip_width = 80 / 2   | endif
if !exists('g:dwm_skip_height')     | let g:dwm_skip_height = 12 / 2  | endif

if g:dwm_default_keys
    nnoremap <silent> <C-j> :wincmd w<CR>
    tnoremap <silent> <C-j> <C-w>w
    nnoremap <silent> <C-k> :wincmd W<CR>
    tnoremap <silent> <C-k> <C-w>W

    if !hasmapto('<Plug>(dwm_focus_window)')
        " Note: Darwin (Apple Terminal) maps 'C-@' to C-Space
        nnoremap <C-@> <Plug>(dwm_focus_window)
        nnoremap <C-Space> <Plug>(dwm_focus_window)
    endif

    if !hasmapto('<Plug>(dwm_new_window)')    | nnoremap <C-n> <Plug>(dwm_new_window)    | endif
    if !hasmapto('<Plug>(dwm_close_window)')  | nnoremap <C-c> <Plug>(dwm_close_window)  | endif
    if !hasmapto('<Plug>(dwm_barrier_right)') | nnoremap <C-l> <Plug>(dwm_barrier_right) | endif
    if !hasmapto('<Plug>(dwm_barrier_left)')  | nnoremap <C-h> <Plug>(dwm_barrier_left)  | endif
endif

" Mark: init
if has('autocmd')
    autocmd VimEnter * call dwm#init()
endif
