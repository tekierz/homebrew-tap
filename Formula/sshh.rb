# Homebrew formula for sshh
# Install: brew install tekierz/tap/sshh

class Sshh < Formula
  desc "Quick SSH connection manager with interactive menu"
  homepage "https://github.com/tekierz/sshh"
  license "MIT"
  head "https://github.com/tekierz/sshh.git", branch: "main"

  # Versioned release (update SHA when creating releases)
  # url "https://github.com/tekierz/sshh/archive/refs/tags/v1.0.1.tar.gz"
  # sha256 "REPLACE_WITH_ACTUAL_SHA256"

  def install
    bin.install "bin/sshh"
    bash_completion.install "share/completions/sshh.bash" => "sshh"
    zsh_completion.install "share/completions/sshh.zsh" => "_sshh"
    fish_completion.install "share/completions/sshh.fish"
  end

  def caveats
    <<~EOS
      To get started:
        sshh edit              # Add your SSH hosts
        sshh                   # Show interactive menu
        sshh 1                 # Connect to first host

      Config file: ~/.sshh
      Format: Name | user@host | port | identity_file

      Example entries:
        Work Server | admin@192.168.1.100
        Home NAS | user@nas.local | 2222
        AWS | ubuntu@ec2.aws.com | 22 | ~/.ssh/aws.pem
    EOS
  end

  test do
    assert_match "sshh version", shell_output("#{bin}/sshh version")
  end
end
