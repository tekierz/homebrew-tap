# Homebrew formula for sshh
# Install: brew install tekierz/tap/sshh

class Sshh < Formula
  desc "Quick SSH connection manager with interactive menu"
  homepage "https://github.com/tekierz/sshh"
  url "https://github.com/tekierz/sshh/archive/refs/heads/main.tar.gz"
  version "1.0.1"
  sha256 "b5c39333f95f274e3bb1353cd40c86c52b817c11380578714544408c91ee5563"
  license "MIT"
  head "https://github.com/tekierz/sshh.git", branch: "main"

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
