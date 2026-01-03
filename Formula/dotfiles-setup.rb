# Homebrew formula for dotfiles-setup
# Install: brew install tekierz/tap/dotfiles-setup

class DotfilesSetup < Formula
  desc "Cross-platform terminal environment setup with 13 customizable themes"
  homepage "https://github.com/tekierz/dotfiles"
  license "MIT"
  head "https://github.com/tekierz/dotfiles.git", branch: "main"

  # Versioned release (update SHA when creating releases)
  # url "https://github.com/tekierz/dotfiles/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "REPLACE_WITH_ACTUAL_SHA256"

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
