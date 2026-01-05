# Homebrew formula for dotfiles TUI (Go)
# Install: brew install tekierz/tap/dotfiles-tui
# NOTE: This is a dev/beta version pointing to feature branch for testing
# The stable bash script is: brew install tekierz/tap/dotfiles-setup

class DotfilesTui < Formula
  desc "Interactive TUI for terminal environment management"
  homepage "https://github.com/tekierz/dotfiles"
  url "https://github.com/tekierz/dotfiles/archive/refs/heads/feature/interactive-tui.tar.gz"
  version "2.0.0-dev"
  sha256 "e72144d81bfd63083a3bcfc6ea7bc229e2214729e4db563b4cb628cfb4629927"
  license "MIT"
  head "https://github.com/tekierz/dotfiles.git", branch: "feature/interactive-tui"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/dotfiles"
  end

  def caveats
    <<~EOS
      Dotfiles TUI has been installed!

      Commands:
        dotfiles              # Launch main menu
        dotfiles install      # Run installation wizard
        dotfiles manage       # Configure installed tools
        dotfiles hotkeys      # View keybindings cheatsheet
        dotfiles update       # Check for package updates
        dotfiles status       # Show current configuration
        dotfiles theme --list # List available themes

      Features:
        - 13 color themes (neon-seapunk, catppuccin, dracula, etc.)
        - Dual-pane configuration editor
        - Cross-platform (macOS, Arch, Debian)
        - Mouse and keyboard navigation

      Note: This is the Go TUI. For the bash setup script, use:
        brew install tekierz/tap/dotfiles-setup
    EOS
  end

  test do
    assert_match "dotfiles", shell_output("#{bin}/dotfiles --help")
  end
end
