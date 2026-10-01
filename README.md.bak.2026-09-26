# Caps Lock Modal Layer

Turns Caps Lock into a held modifier that gives you vim-style navigation and
editing everywhere on Linux — not just in a text editor. Built on
[kanata](https://github.com/jtroo/kanata), which reads and writes keys at the
kernel evdev/uinput level, so it works system-wide regardless of X11 or
Wayland (built and tested on Fedora + KDE Plasma/Wayland).

## Why

Vim motions don't work outside real vim/Neovim — every "vim mode" bolted
onto another app is a partial reimplementation with its own gaps. Arrow keys
work everywhere, but reaching for them is slow. This puts arrow-key
navigation (plus a few vim-shaped editing commands) on the home row, built
entirely out of shortcuts every app already understands
(Ctrl+Arrow, Shift+Arrow, Ctrl+Shift+Arrow) — so it never depends on an
app's own vim plugin being any good.

## Quick start

```sh
git clone <repo-url> ~/.config/kanata
~/.config/kanata/install.sh
```

The script downloads the kanata binary if you don't have it, sets up the
`input`/`uinput` permissions (needs sudo, one-time), installs the config,
and enables it as a systemd user service that starts on login and restarts
on failure.

First time being added to the `input`/`uinput` groups: log out and back in
once for it to take effect.

Check it's running:
```sh
systemctl --user status kanata.service
```

## Usage

Hold **Caps Lock** to enter the nav layer. Release it and you're typing
normally — nothing is remapped unless Caps is held.

| Key (while holding Caps) | Action |
|---|---|
| `h` `j` `k` `l` | Left / Down / Up / Right |
| `w` | Jump forward one word |
| `b` | Jump backward one word |
| `e` | Jump forward one word (approximation — see note below) |
| `u` | Undo |
| `y` | Copy (acts on the current selection) |
| `d`, `d` | Delete the current line |
| `d`, `i`, `w` | Delete the word under the cursor |
| `v` | Toggle visual mode |

**Visual mode** (`v`): `h`/`j`/`k`/`l`/`w`/`b`/`e` extend a selection instead
of just moving. `d` cuts the selection and exits back to normal mode; `y`
copies it and exits. Press `v` again to bail out without doing anything.

### Note on `e`

Real vim's `e` (end of word) and `w` (start of next word) are genuinely
different motions. There's no OS-native "end of word" shortcut to build `e`
on, so here it's mapped to the same thing as `w`. Close enough in practice,
not identical to vim.

## Files

- `kanata.kbd` — the config: all key layers and bindings
- `kanata.service` — systemd user unit, starts kanata on login, restarts on failure
- `install.sh` — installs everything above; safe to re-run

## Known gaps

- Releasing Caps Lock mid-selection while visual mode is active hasn't been
  tested. If it misbehaves, finish the selection first (`d`, `y`, or `v` to
  exit) before letting go of Caps.
- `install.sh`'s binary-download path (for a machine without kanata already
  installed) hasn't been exercised on a genuinely fresh machine. If the
  release zip's internal filename doesn't match what the script expects,
  it prints the zip's contents instead of failing silently — fix the
  `-iname` pattern in that case.

## How it works

kanata intercepts raw keyboard events at the evdev level — below X11,
Wayland, and the compositor — and emits synthetic key presses via uinput.
Because of that:

- It behaves the same regardless of window manager or app: anything an OS
  shortcut reaches, this reaches.
- It sits below compositor-level key remaps (e.g. KDE's Caps↔Esc swap via
  XKB) — the two don't conflict, since kanata sees the true physical key
  before that remap is ever applied.
- It can't fake anything an app doesn't already support. `d`,`i`,`w` isn't a
  real "delete inner word" — it's "select the word under the cursor with
  the OS's own word-select shortcut, then delete." It rides on shortcuts
  every app already implements rather than reimplementing vim's text-object
  model from scratch.

## Requirements

- Linux with `uinput` kernel module support
- `curl`, `unzip`, `sudo`, `systemd --user`
