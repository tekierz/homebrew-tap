# Run with ruby test/dotfiles_ownership_test.rb. No package build or install runs.
require "minitest/autorun"
require "pathname"
require "tmpdir"
require "fileutils"

class Formula
  def self.method_missing(*) = nil
  def self.respond_to_missing?(*) = true
  def self.test(*) = nil
  def std_go_args(**options)
    @build_options = options
    ["-o", "isolated-keg/bin/dotfiles"]
  end
  def version = "2.0.1"
  def ohai(*) = nil
  attr_reader :build_command, :build_options
  def system(*args)
    @build_command = args
    true
  end
end

load ENV.fetch("DOTFILES_FORMULA", File.expand_path("../Formula/dotfiles.rb", __dir__))

class DotfilesOwnershipTest < Minitest::Test
  [:file, :symlink, :dangling_symlink].each do |kind|
    define_method("test_install_preserves_#{kind}") do
      Dir.mktmpdir("formula-ownership") do |dir|
        prefix = Pathname.new(dir)
        FileUtils.mkdir_p(prefix/"bin")
        Object.const_set(:HOMEBREW_PREFIX, prefix)
        paths = %w[dotfiles-tui dotfiles-setup].map { |name| prefix/"bin"/name }
        paths.each do |path|
          case kind
          when :file
            path.write("user-owned #{path.basename}\n")
            path.chmod(0751)
          when :symlink
            target = prefix/"owned-#{path.basename}"
            target.write("external owner\n")
            File.symlink(target, path)
          when :dangling_symlink
            File.symlink(prefix/"missing-#{path.basename}", path)
          end
        end
        before = paths.map { |path| snapshot(path) }
        formula = Dotfiles.new
        formula.install
        paths.zip(before).each do |path, original|
          assert path.exist? || path.symlink?, "removed #{kind}: #{path.basename}"
          assert_equal original, snapshot(path), "changed #{kind}: #{path.basename}"
        end
        assert_equal ["go", "build", "-o", "isolated-keg/bin/dotfiles", "./cmd/dotfiles"], formula.build_command
        assert_equal({ ldflags: "-s -w -X main.version=2.0.1" }, formula.build_options)
      ensure
        Object.send(:remove_const, :HOMEBREW_PREFIX) if Object.const_defined?(:HOMEBREW_PREFIX)
      end
    end
  end

  private

  def snapshot(path)
    stat = path.lstat
    result = { inode: stat.ino, mode: stat.mode, type: stat.ftype }
    if path.symlink?
      result[:link] = path.readlink.to_s
      result[:target] = path.exist? ? path.read : :missing
    else
      result[:content] = path.read
    end
    result
  end
end
