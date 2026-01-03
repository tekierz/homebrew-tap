# Homebrew formula for dotfiles-setup
# Install: brew install tekierz/tap/dotfiles-setup

class DotfilesSetup < Formula
  desc "Cross-platform terminal environment setup with 13 customizable themes"
  homepage "https://github.com/tekierz/dotfiles"
  url "https://github.com/tekierz/dotfiles/archive/refs/heads/main.tar.gz"
  version "1.0.0"
  sha256 "d4d0e0d3fbe61a2e7d3432d2b9340e6587d2ff035d2268be970ab15a26237c3b"
  license "MIT"
  head "https://github.com/tekierz/dotfiles.git", branch: "main"

  def install
    bin.install "bin/dotfiles-setup"
  end

  def caveats
    <<~EOS
      To set up your terminal environment, run:
        dotfiles-setup

      This will install and configure:
        - zsh with syntax highlighting & autosuggestions
        - tmux with powerline status bar
        - Ghostty terminal (13 color themes)
        - yazi file manager
        - fzf, bat, eza, zoxide, delta
        - neovim (Kickstart.nvim)
        - Disk tools: ncdu, duf, dust
        - Network tools: bandwhich, gping, dog, trippy
        - Custom utilities: hk, caff, sshh, dotfiles

      After installation:
        - Run 'dotfiles theme <name>' to switch themes
        - Run 'dotfiles status' to see current settings
        - Run 'hk' to see all keyboard shortcuts
    EOS
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/dotfiles-setup --help", 0)
  end
end
