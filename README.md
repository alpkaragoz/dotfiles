# dotfiles

Personal shell configuration. No frameworks, no bloat -- just zsh with a modular config structure.

## What's included

**Zsh** -- modular config split into `~/.zsh/`:

| File | Purpose |
|---|---|
| `options.zsh` | Shell behavior flags |
| `history.zsh` | 100k shared history with dedup |
| `completion.zsh` | Menu-driven, case-insensitive completion with caching |
| `prompt.zsh` | Two-line prompt: path, git status, command timer, exit code |
| `keybindings.zsh` | Word jump, prefix history search, Ctrl+Z toggle, editor edit |
| `aliases.zsh` | 70+ shortcuts for git, maven, docker, kubectl |
| `functions.zsh` | `extract`, `mkcd`, `ports`, `tre`, `serve`, `proj`, `kpf`, `docker-help` |
| `tools.zsh` | NVM, SDKMAN, syntax highlighting, autosuggestions |
| `local.zsh` | Machine-specific overrides (gitignored) |

## Setup

```bash
git clone https://github.com/alpkaragoz/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

The installer backs up existing configs to `~/.dotfiles-backup/` before creating symlinks.

### Reloading the config

After installation, open a new Zsh terminal or reload the config from an existing Zsh session:

```zsh
source ~/.zshrc
```

The installer links `~/.zshrc` and `~/.zsh` to this repository, so keep the clone in place. Edits to the linked config files take effect when you reload the shell config.

### Dependencies

Install the recommended packages for your system:

```bash
# Debian / Ubuntu / Mint
sudo apt install zsh-syntax-highlighting zsh-autosuggestions

# Arch
sudo pacman -S zsh-syntax-highlighting zsh-autosuggestions

# macOS
brew install zsh-syntax-highlighting zsh-autosuggestions
```

### Machine-specific config

After install, edit `~/.zsh/local.zsh` for anything specific to the current machine (work env vars, IDE integrations, etc.). This file is gitignored.

## Prompt

```
~/projects/my-api  main *2 +1 ↑3
❯ _
```

- **Bold blue** directory path
- **Yellow** git branch with status indicators: `*` unstaged, `+` staged, `?` untracked, `↑↓` ahead/behind
- **Green/red** prompt character reflects last command's exit code
- **Command timer** appears on the right for anything over 3 seconds

## Key bindings

| Key | Action |
|---|---|
| `Ctrl+Left/Right` | Jump by word |
| `Ctrl+Backspace` | Delete word left |
| `Up/Down` | Prefix history search |
| `Ctrl+X Ctrl+E` | Edit command in `$EDITOR` |
| `Ctrl+Z` | Resume background job (empty line) / stash current input (text in line) |
| `Shift+Tab` | Reverse through completion menu |

## Keeping things up to date

Pull the latest changes, then reload the config from a Zsh session:

```zsh
cd ~/dotfiles
git pull --ff-only
source ~/.zshrc
```

Keep machine-specific settings in `~/.zsh/local.zsh`; it is loaded after the shared modules and stays outside version control.
