# Homebrew Tap

Homebrew formulae for tekierz tools.

## Installation

```bash
brew tap tekierz/tap
```

## Available Formulae

### dotfiles

Cross-platform terminal environment management TUI with 16 customizable themes.

```bash
brew install tekierz/tap/dotfiles
dotfiles
```

**Features:**
- Interactive TUI with dual-pane configuration editor
- 16 color themes (neon-seapunk, catppuccin, dracula, etc.)
- zsh with syntax highlighting & autosuggestions
- tmux with powerline status bar
- Ghostty terminal with unified themes
- yazi file manager, fzf, bat, eza, zoxide
- neovim (Kickstart.nvim)
- Disk analysis: ncdu, duf, dust
- Network analysis: bandwhich, gping, doggo, trippy
- Mouse and keyboard navigation
- Streaming install logs
- Batch package updates

**Commands:**
- `dotfiles` - Launch main menu
- `dotfiles install` - Run installation wizard
- `dotfiles manage` - Configure installed tools
- `dotfiles hotkeys` - View keybindings cheatsheet
- `dotfiles update` - Check for package updates
- `dotfiles status` - Show current configuration
- `dotfiles theme --list` - List available themes

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

## Migration from Legacy Packages

If you previously had `dotfiles-setup` or `dotfiles-tui` installed, the new unified `dotfiles` formula will automatically clean them up during installation.

```bash
# Uninstall old packages (if installed)
brew uninstall tekierz/tap/dotfiles-setup 2>/dev/null
brew uninstall tekierz/tap/dotfiles-tui 2>/dev/null

# Install the new unified package
brew install tekierz/tap/dotfiles
```

## Development

To install from HEAD (latest main branch):

```bash
brew install --HEAD tekierz/tap/dotfiles
brew install --HEAD tekierz/tap/sshh
```

## License

MIT
