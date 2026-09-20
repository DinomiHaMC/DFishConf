<h1 align="center">DFishC</h1>

<p align="center">
  A practical, modular <a href="https://fishshell.com/">Fish</a> setup and an interactive Linux workstation bootstrapper.
</p>

<p align="center">
  <img src="https://ins.dinomiha.ru/fetch.png" alt="DFishC system summary" width="720">
</p>

<p align="center">
  <img src="https://ins.dinomiha.ru/Command-line.png" alt="DFishC command line" width="383">
</p>

<p align="center">
  <a href="README.ru.md">Русский</a> ·
  <a href="#quick-start">Quick start</a> ·
  <a href="#what-is-included">What is included</a> ·
  <a href="#safety-and-behaviour">Safety</a>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0--or--later-blue.svg" alt="GPL-3.0-or-later license"></a>
  <img src="https://img.shields.io/badge/platform-Linux-1793d1.svg" alt="Linux">
  <img src="https://img.shields.io/badge/shell-Fish-34c534.svg" alt="Fish shell">
</p>

> [!WARNING]
> The installer can install packages, change the login shell, and replace configuration files. Read it before running it, choose the manual mode when in doubt, and keep backups of anything important.

## Quick start

### One-line installer (recommended)

```bash
curl -fsSL https://ins.dinomiha.ru/dfish | bash
```

This is the primary installation method. The script stays interactive and reads your answers from the terminal.

### Clone the repository

Use a local checkout when you want to inspect or customise the project before installing:

```bash
git clone https://github.com/DinomiHaMC/DFishConf.git ~/DFishC
bash ~/DFishC/ins.sh
```

The installer is interactive. It accepts `y`/`yes` and `д`/`да`; an empty reply means “no”. Log out and back in after changing the shell.

## What is included

| Component | Purpose |
| --- | --- |
| `dots/fish/` | Modular Fish configuration, functions, integrations, and conditional aliases. |
| `dots/kitty/` | Kitty terminal configuration and colour theme. |
| `dots/starship.toml` | Starship prompt configuration. |
| `ins.sh` | Interactive installer for packages, configs, Fish, and optional tools. |
| `DFetch.sh` | A compact Fish/DFishC system summary. |
| `DSort.sh` | Sorts `~/Downloads` into media, code, and document directories. |

The Fish configuration is intentionally split by responsibility: paths, environment, terminal aliases, utilities, editors, package managers, Python, integrations, and startup. Files in `conf.d/` load in lexical order.

## Platform support

| System | Package source | Notes |
| --- | --- | --- |
| Arch Linux and derivatives | `pacman`, optionally `yay` | Installs `yay` if requested and unavailable. |
| Debian and Ubuntu derivatives | `apt` | Some optional TUI packages may need manual installation. |
| NixOS | `nix profile` | The installer also prints a declarative `configuration.nix` example. |

An unrecognised system can continue without distribution-specific package installation.

## Safety and behaviour

In automatic mode, `ins.sh` can install the base terminal toolkit, zapret, LazyVim, FastCommanderTUI, configuration files, and Fish startup integration. Manual mode asks before every component.

External source projects that execute during installation are pinned to specific commits. Existing config and script targets are moved to:

```text
~/.local/state/dfishc/backups/<timestamp>/
```

LazyVim is fetched into a temporary directory and only replaces `~/.config/nvim` after the download is verified. The configuration content is copied into `~/.config/`; it does not symlink the repository.

### Installed toolkit

The exact list varies by platform, but includes Fish, Git, Neovim, Starship, Zoxide, Fastfetch, LSD, Btop, Bat, Lazygit, Python, Cargo, OpenSSH, Docker, and NTFS support. Arch systems additionally attempt `lazyssh`, `lazydocker`, and `superfile` through the AUR.

> [!NOTE]
> On NixOS, enable Fish, Docker, and the user shell declaratively in `/etc/nixos/configuration.nix`; the installer prints the required snippet.

## Fish experience

DFishC adds practical paths for local binaries, Nix profiles, Cargo, and Go. It initializes Zoxide, Pyenv, and Starship when present, and starts Fastfetch only in interactive shells.

DFishC preserves the terminal's `TERM` value, so `nano` is neither wrapped nor given a custom terminal type: running `nano` uses the normal command and environment. Use `kit <command>` only for programs that specifically need Kitty terminal capabilities.

### Selected commands

| Command | Action |
| --- | --- |
| `na`, `sna` | Open Nano, or Nano through `sudo`. |
| `nv`, `snv` | Open Neovim with Kitty capabilities, normally or through `sudo`. |
| `ff`, `mon`, `bt` | Run Fastfetch, Btop, and Bat/Batcat when installed. |
| `l`, `la`, `lla`, `lt` | Useful `ls` views; uses LSD when available. |
| `gc`, `ga`, `gcm`, `gp` | Git clone, add, commit, and push shortcuts. |
| `ai`/`au`, `pacs`/`pacupd`, `ys`/`yupd` | Apt, Pacman, and Yay shortcuts, defined only when available. |
| `proxy <command>` | Run a command with local HTTP/HTTPS proxy variables. |
| `DFishC-fetch`, `DFishC-update` | Run the bundled summary or update a clone in `~/DFishC`. |

Run `alias` in Fish to see the aliases available on your machine. Commands that depend on an installed program are created conditionally.

### Functions

| Function | Action |
| --- | --- |
| `ffinder <query>` | Opens a Google search in a new Firefox window. |
| `n [path]` | Opens Nautilus in the current directory or at a path. |
| `use <path-or-url>` | Opens URLs and files with an appropriate application; directories are entered. |
| `clean` | Cleans supported package-manager caches and journal logs. Review its implementation before running: it removes data. |

## Download sorter

`DSort.sh` creates `~/Audios`, `~/Pictures`, `~/Videos`, `~/Code`, and `~/Docs` when needed, then moves files from `~/Downloads` by extension. Files not matching a known media or code extension go to `~/Docs`.

```bash
bash ~/DSort.sh
```

## Updating and uninstalling

To update a checkout:

```bash
cd ~/DFishC
git pull
bash ins.sh
```

There is no destructive one-command uninstaller. Restore the files saved under `~/.local/state/dfishc/backups/`, remove the copied directories from `~/.config/` as appropriate, and revert the Fish login-shell or `.bashrc` changes if you enabled them.

## Contributing

Issues and pull requests are welcome. Please keep Fish configuration modular, make aliases conditional when they rely on optional commands, and test the installer syntax before submitting changes:

```bash
bash -n ins.sh
fish -n dots/fish/config.fish dots/fish/conf.d/*.fish dots/fish/functions/*.fish
```

## License

DFishC is distributed under the [GNU GPL v3.0 or later](LICENSE).
