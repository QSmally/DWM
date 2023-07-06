
# Tiling window manager for Vim

`dwm.vim` adds tiled window management to Vim. It is highly inspired by [dwm](http://dwm.suckless.org/)
(Dynamic Window Manager) tiled layout management. Windows are always organised defined by the
following layout, consisting of a master pane on the left and a stacked pane on the right side.

<pre align="center"><code>
+--------------+------------------+   +--------------+------------------+
|              |        S1        |   |              |        S1        |
|              |                  |   |              | ---------------- |
|              | ---------------- |   |      M0      |        S2        |
|      M0      |        S2        |   |              | ---------------- |
|              |                  |   |              |        S3        |
|              | ---------------- |   +--------------+------------------+
|              |        S3        |   |      qf                         |
+--------------+------------------+   +---------------------------------+
</code></pre>

Fork (detached) from [spolu/dwm.vim](https://github.com/spolu/dwm.vim) with fixes and my private
contributions.

### Commands and bindings

- `<C-N>` `:New` - spawn a new empty window in the master pane,
- `<C-P>` - enter dmenu-like `:New[!]` to open a file in the master or stack pane,
- `[w]<C-C>` `:[w]Close` - close `[w]` or current window and adjusts layout,
- `[w]<C-@>` `:[w]Switch` - focus `[w]`, current or first window on the master pane,
- `:WRR` - rotate window layout to the right,
- `:WRL` - rotate window layout to the left,
- `<C-L>` `:WBR` - move center barrier to the right,
- `<C-H>` `:WBL` - move center barrier to the left,
- `<C-J>` - change cursor position to next window,
- `<C-K>` - change cursor position to previous window,
- `<C-M>` - jump cursor position to first/master pane.

### Upcoming changes and todo

* Toggleable 80-column (and customisable) master pane width or 50% when >80 columns is available,
* In low-width sessions, automatically do inline resizing of currently-focussed window,
* `:DWM` (and `:DWM!`) command to toggle functionality through a session.

### Preview of the tiled layout

<!-- Old one to display no qf window -->
![](http://i.imgur.com/TKL4i.png)
<!-- If a new one is wanted -->
<!-- ![](http://i.imgur.com/yXCntB2.png) -->

![](http://i.imgur.com/GsjB1od.png)

## Installation

Install to `~/.vim/plugin/dwm.vim` and `~/.vim/autoload/dwm.vim`, or use Vim-Plug,
`Plug 'QSmally/DWM'`.

```
mkdir -p ~/.vim/plugin ~/.vim/autoload ~/.vim/doc; \
wget -qO ~/.vim/plugin/dwm.vim https://raw.github.com/QSmally/DWM/master/plugin/dwm.vim; \
wget -qO ~/.vim/autoload/dwm.vim https://raw.github.com/QSmally/DWM/master/autoload/dwm.vim; \
wget -qO ~/.vim/doc/dwm.txt https://raw.github.com/QSmally/DWM/master/doc/dwm.txt
```

You can use `curl -so` if you prefer it over `wget`.

## Configuration

- `g:dwm_default_keys`: if set to a falsey value, prevents key mapping.
- `g:dwm_master_pane_width`: set the width of the master pane (e.g. `g:dwm_master_pane_width=85`)

<!-- TODO: Expand doc to README -->

To get fullscreen-mode capability, I recommend using `taylor/vim-zoomwin`:

```vimscript
Plug 'taylor/vim-zoomwin'
nnoremap <silent> <C-q> :ZoomWin<CR>
```

To use a mouse to select windows and resize panes:

- `set mouse=a`: enable the use of the mouse in all modes,
- `set ttymouse=xterm2`: recognise mouse codes for the xterm2 terminal type.

## Remarks

There is only one tiled layout available right now, but do not hesitate to *fork it!*

For fun, I urge you to try using `dwm.vim` in `vim`, in `tmux`, in `ssh`, in `tmux`, in `xterm`, in `dwm`.

Thanks Uriel (*luriel* on HackerNews) for this awesome comment on the [HN post](http://news.ycombinator.com/item?id=4419530) 
related to `dwm.vim`:

> As one of the original instigators of dwm and wmii before that (mostly by shouting at garbeam) 
> I want to point out that this kind of tiled window management was first introduced in larswm 
> (that is sadly discontinued), which in turn was heavily inspired by Rob Pike's Acme editing 
> environment ( http://acme.cat-v.org ). 
>
> So in a way we have gone full circle, from text editor, to window managers, back to text editor.
>
> That said, I still prefer Acme to vim, but would be really cool if somebody added mouse chording to vim :)
