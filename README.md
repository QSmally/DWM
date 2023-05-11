
# Tiling window manager for Vim

`dwm.vim` adds tiled window management to Vim. It is highly inspired by [dwm](http://dwm.suckless.org/)
(Dynamic Window Manager) tiled layout management.

Fork (detached) from [spolu/dwm.vim](https://github.com/spolu/dwm.vim) with fixes and my private
contributions.

Layouts are always organised as follows:

```
===================================
|              |        S1        | 
|              |==================|
|      M       |        S2        | 
|              |==================|
|              |        S3        | 
===================================
```

- `<C-N>` `:New` - spawn a new empty window in the master pane,
- `<C-C` `:Close` - close the current window, and if it was the master pane, fixes layout
- `<C-Space>` `:Switch` - switch current window to master pane, or switch with top of stack,
- `:WRR` - rotate windows to the right,
- `:WRL` - rotate windows to the left,
- `<C-L>` `:WBR` - move barrier to the right,
- `<C-H>` `:WBL` - move barrier to the left,
- `<C-J>` - change cursor position to the next window,
- `<C-K>` - change cursor position to the previous window.

**Todo** for the fork of DWM:

* 80 column width for floating windows (help, fugitive, etc),
* `[window]C-Space` to focus a window which is on the stacked pane [S],
* `:DWM` command to toggle functionality (and save it to a session).

![](http://i.imgur.com/TKL4i.png)

### Installation

Install to `~/.vim/plugin/dwm.vim` or use Vim-Plug, `Plug 'QSmally/DWM'`.

```
mkdir -p ~/.vim/plugin ~/.vim/doc; \
wget -qO ~/.vim/plugin/dwm.vim \
    https://raw.github.com/spolu/dwm.vim/master/plugin/dwm.vim; \
wget -qO ~/.vim/doc/dwm.txt \
    https://raw.github.com/spolu/dwm.vim/master/doc/dwm.txt;
```

You can use `curl -so` if you prefer it over `wget`.

### Optional Settings

- `g:dwm_map_keys`: if set to a falsey value, prevents key mapping.
- `g:dwm_master_pane_width`: set the width of the master pane (e.g. `g:dwm_master_pane_width=85`)

To use a mouse to select windows and resize panes:
- `set mouse=a`: enable the use of the mouse in all modes
- `set ttymouse=xterm2`: recognize mouse codes for the xterm2 terminal type

### Remarks

There is only one tiled layout available right now, but do not hesitate to *fork it*!

For fun, I urge you to try using `dwm.vim` in `vim`, in `tmux`, in `ssh`, in `tmux`, in `xterm`, in `dwm`.

Thanks Uriel (✝) (*luriel* on HackerNews) for this awesome comment on the [HN post](http://news.ycombinator.com/item?id=4419530) 
related to `dwm.vim`:

> As one of the original instigators of dwm and wmii before that (mostly by shouting at garbeam) 
> I want to point out that this kind of tiled window management was first introduced in larswm 
> (that is sadly discontinued), which in turn was heavily inspired by Rob Pike's Acme editing 
> environment ( http://acme.cat-v.org ). 
> So in a way we have gone full circle, from text editor, to window managers, back to text editor.
> That said, I still prefer Acme to vim, but would be really cool if somebody added mouse chording to vim :)

### Contributors

```
@dsapala (Dan Sapala)
@rhacker
@matze (Matthias Vogelgesang)
@mitnk
@tony (Tony Narlock)
@lmarburger (Larry Marburger)
@afriggeri (Adrien)
@n4kz (Alexander Nazarov)
```

