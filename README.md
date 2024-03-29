
# Tiling window manager for Vim

`dwm.vim` adds tiled window management to Vim. It's highly inspired by [dwm](https://dwm.suckless.org/)
(Dynamic Window Manager) tiled layouts. Windows are always organised defined by the following
layout, consisting of a master pane on the left and a stacked pane on the right.

```
+------------------+------------------+   +------------------+------------------+
|                  |        S1        |   |                  |        S1        |
|                  | ________________ |   |                  | ---------------- |
|                  |                  |   |        M0        |        S2        |
|        M0        |        S2        |   |                  | ---------------- |
|                  | ________________ |   |                  |        S3        |
|                  |                  |   +------------------+------------------+
|                  |        S3        |   |        qf                           |
+------------------+------------------+   +-------------------------------------+
```

Fork (detached) from [spolu/dwm.vim](https://github.com/spolu/dwm.vim) with fixes and my private
contributions.

### Commands and bindings

- `:New` - spawn a new empty window in the master pane,
- `[w]<C-C>` `:[w]Close` - close `[w]` or current window and adjusts layout,
- `[w]<C-@>` `:[w]Switch` - focus `[w]`, current or first window on the master pane,
- `:WRR` - rotate window layout to the right,
- `:WRL` - rotate window layout to the left,
- `<C-L>` `:WBR` - move center barrier to the right,
- `<C-H>` `:WBL` - move center barrier to the left,
- `<C-J>` - change cursor position to next window,
- `<C-K>` - change cursor position to previous window.

The QuickFix window stays in place whenever a window operation is done.

### Upcoming changes and todo

* In low-width sessions, automatically do inline resizing of currently-focussed window,
* Tiling modes like Suckless DWM and awesomewm, including floating windows, monocle layout.

### Preview of the tiled layout

<!-- Old one to display no qf window -->
![](http://i.imgur.com/TKL4i.png)

<!-- If a new one is wanted -->
<!-- ![](http://i.imgur.com/yXCntB2.png) -->

<!-- TODO: New colourscheme screenshot -->
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

- `g:dwm_default_keys`: if set to a falsey value, prevents key mapping,
- `g:dwm_enable_width`: total columns in order for DWM behaviour to enable,
- `g:dwm_master_pane_width`: set the width of the master pane in percentage or columns,
- `g:dwm_skip_width`/`height`: (half of) window column in order to ignore window from layout.

To get monocle-like capability, I recommend using [`taylor/vim-zoomwin`](https://github.com/taylor/vim-zoomwin):

```vimscript
Plug 'taylor/vim-zoomwin'
nnoremap <silent> <C-q> :ZoomWin<CR>
```

To get dmenu-like capability, I recommend using [`ctrlpvim/ctrlp.vim` (fork from `kien/ctrlp.vim`)](https://github.com/ctrlpvim/ctrlp.vim):

```vimscript
Plug 'ctrlpvim/ctrlp.vim'
```

To use a mouse to select windows and resize panes:

- `set mouse=a`: enable the use of the mouse in all modes,
- `set ttymouse=xterm2`: recognise mouse codes for the xterm2 terminal type.

## Remarks

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
