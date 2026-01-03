# Homebrew Tap

Homebrew formulae for tekierz tools.

## Installation

```bash
brew tap tekierz/tap
```

## Available Formulae

### dotfiles-setup

Cross-platform terminal environment setup with 13 customizable themes.

```bash
brew install tekierz/tap/dotfiles-setup
dotfiles-setup
```

**Features:**
- zsh with syntax highlighting & autosuggestions
- tmux with powerline status bar
- Ghostty terminal with unified themes
- yazi file manager, fzf, bat, eza, zoxide
- neovim (Kickstart.nvim)
- Disk analysis: ncdu, duf, dust
- Network analysis: bandwhich, gping, dog, trippy

[Repository](https://github.com/tekierz/dotfiles) | [Documentation](https://github.com/tekierz/dotfiles#readme)

### sshh

Quick SSH connection manager with interactive menu.

```bash
brew install tekierz/tap/sshh
sshh edit    # Add hosts
sshh         # Connect
```

**Features:**
- Interactive menu for SSH connections
- Direct connect by number (`sshh 1`)
- Custom port and identity file support
- Shell completions (bash, zsh, fish)

[Repository](https://github.com/tekierz/sshh) | [Documentation](https://github.com/tekierz/sshh#readme)

## Development

To install from HEAD (latest main branch):

```bash
brew install --HEAD tekierz/tap/dotfiles-setup
brew install --HEAD tekierz/tap/sshh
```

## License

MIT
