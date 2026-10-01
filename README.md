# Caps Text Controls

A small, system-wide text-editing layer built with [Kanata](https://github.com/jtroo/kanata). Hold **Caps Lock** to move, select, and make simple line edits with familiar home-row keys. It uses ordinary operating-system shortcuts, so it works across apps without relying on each app's Vim plugin.

## Controls

Hold **Caps Lock** to activate the layer. Release it to return to normal typing.

| Keys while holding Caps | Action |
|---|---|
| `h` / `j` / `k` / `l` | Move left / down / up / right |
| `b` / `w` | Jump backward / forward by a word |
| `n` / `m` | Select the current word, then extend selection backward / forward with repeated presses |
| `e` | Select the current line |
| `o` | Move to the end of the line and insert a line break below |
| `0` / `Shift+4` (`$`) | Move to the start / end of the line |
| `u` / `p` / `del` | Undo / paste / delete |

### Word selection mode

Hold **Caps+V** and use:

| Keys while holding Caps+V | Action |
|---|---|
| `h` / `j` / `k` / `l` | Extend selection left / down / up / right |
| `b` / `w` | Extend selection backward / forward by a word |

Release **V** to return to the regular Caps layer. The `n` and `m` word-selection bindings remain available in the regular layer.

## Install

From a clone of this repository, run:

```sh
./install.sh
```

The installer places the config at `~/.config/kanata`, installs and enables a systemd user service, and sets up Linux `uinput` permissions. It uses `sudo` for system-level permissions. If it adds your account to the `input` or `uinput` groups, log out and back in once before using Kanata.

Check the service with:

```sh
systemctl --user status kanata.service
```

After editing the config, restart it with:

```sh
systemctl --user restart kanata.service
```

## Configuration

- `kanata.kbd` loads the interface bindings and Caps layer.
- `vim/1-interface.kbd` maps common actions to operating-system shortcuts. Linux is the configured platform; Windows and macOS mappings are marked experimental.
- `vim/4-normal-layer.kbd` defines the Caps navigation, selection, and line actions.
- `kanata.service` runs the configuration as a systemd user service.
- `install.sh` installs the binary, permissions, config, and service.

Caps Lock is consumed while Kanata is running and acts only as a held modifier in this setup; its normal Caps Lock toggle is suppressed.
