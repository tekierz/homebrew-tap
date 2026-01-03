# Homebrew formula for sshh
# Install: brew install tekierz/tap/sshh

class Sshh < Formula
  desc "Quick SSH connection manager with interactive menu"
  homepage "https://github.com/tekierz/sshh"
  url "https://github.com/tekierz/sshh/archive/refs/heads/main.tar.gz"
  version "1.1.0"
  sha256 "3ec717fc16877f3e545f8418d6a3290695eaab43b06479a628f3f47f18b8b5a0"
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
