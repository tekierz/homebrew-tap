#!/bin/bash
# Real install/uninstall acceptance. Execute only on a disposable hosted macOS VM.
set -euo pipefail

[[ "${GITHUB_ACTIONS:-}" == "true" && "${RUNNER_ENVIRONMENT:-}" == "github-hosted" ]]
[[ "${RUNNER_OS:-}" == "macOS" && "$(uname -s)" == "Darwin" ]]
: "${RUNNER_TEMP:?}"
: "${GITHUB_WORKSPACE:?}"

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_AUTOREMOVE=1
export HOMEBREW_NO_ANALYTICS=1

trial_prefix="$(brew --prefix)"
case "$(uname -m):$trial_prefix" in
  arm64:/opt/homebrew|x86_64:/usr/local) ;;
  *) echo "Unexpected hosted-runner Homebrew prefix" >&2; exit 1 ;;
esac
trial_formula="${GITHUB_WORKSPACE}/Formula/dotfiles.rb"
trial_tap="ownership/acceptance"
trial_name="$trial_tap/dotfiles"
trial_tap_dir="$(brew --repository)/Library/Taps/ownership/homebrew-acceptance"
trial_cellar="$(brew --cellar)/dotfiles"
for path in "$trial_prefix/bin/dotfiles" "$trial_prefix/opt/dotfiles" "$trial_cellar" \
  "$trial_prefix/bin/dotfiles-tui" "$trial_prefix/bin/dotfiles-setup" "$trial_tap_dir"; do
  if [[ -e "$path" || -L "$path" ]]; then
    echo "Preexisting acceptance target: $path" >&2
    exit 1
  fi
done

trial_dir="$(mktemp -d "$RUNNER_TEMP/dotfiles-homebrew.XXXXXX")"
# Register a separate local tap, without fetching or changing the public tap.
brew tap-new --no-git "$trial_tap"
cp "$trial_formula" "$trial_tap_dir/Formula/dotfiles.rb"
cmp "$trial_formula" "$trial_tap_dir/Formula/dotfiles.rb"
shasum -a 256 "$trial_formula"
brew --version

# Ruby snapshots preserve inode, mode, bytes and symlink/target identities.
# No fixture is executed. Refuse cleanup if any accepted identity has changed.
cat > "$trial_dir/fixture.rb" <<'RUBY'
require "json"
require "digest"
def snapshot(path)
  stat = File.lstat(path)
  value = {"dev"=>stat.dev,"ino"=>stat.ino,"mode"=>stat.mode,"type"=>stat.ftype}
  if stat.symlink?
    value["link"] = File.readlink(path)
    value["target"] = File.exist?(path) ? snapshot(File.realpath(path)) : "missing"
  else
    value["sha256"] = Digest::SHA256.file(path).hexdigest
  end
  value
end
mode, state, prefix, root, kind = ARGV
paths = %w[dotfiles-tui dotfiles-setup].map { |name| File.join(prefix,"bin",name) }
if mode == "create"
  paths.each do |path|
    raise "preexisting fixture" if File.exist?(path) || File.symlink?(path)
    case kind
    when "file"
      File.write(path,"unrelated owner: #{File.basename(path)}\n",mode:"wx",perm:0751)
    when "symlink", "dangling"
      target = File.join(root,File.basename(path))
      File.write(target,"external target\n",mode:"wx",perm:0640) if kind == "symlink"
      File.symlink(target,path)
    else
      raise "unknown case"
    end
  end
  File.write(state,JSON.generate(paths.to_h { |path| [path,snapshot(path)] }),mode:"wx",perm:0600)
else
  expected = JSON.parse(File.read(state))
  expected.each { |path,value| raise "fixture changed: #{path}" unless snapshot(path) == value }
  expected.each_key { |path| File.unlink(path) } if mode == "remove"
end
RUBY

# Three installs use the same immutable source/hash. Each case creates its own
# snapshots and removes only unchanged fixtures after successful uninstall.
for trial_kind in file symlink dangling; do
  trial_case="$trial_dir/$trial_kind"
  mkdir "$trial_case"
  trial_state="$trial_case/state.json"
  ruby "$trial_dir/fixture.rb" create "$trial_state" "$trial_prefix" "$trial_case" "$trial_kind"
  brew install --build-from-source "$trial_name"
  ruby "$trial_dir/fixture.rb" verify "$trial_state" "$trial_prefix" "$trial_case"
  brew test "$trial_name"
  "$trial_prefix/bin/dotfiles" --help
  trial_version="$("$trial_prefix/bin/dotfiles" version)"
  [[ "$trial_version" == "dotfiles version 2.0.1" ]]
  printf '%s\n' "$trial_version"
  brew uninstall "$trial_name"
  [[ ! -e "$trial_prefix/bin/dotfiles" && ! -L "$trial_prefix/bin/dotfiles" ]]
  [[ ! -e "$trial_prefix/opt/dotfiles" && ! -L "$trial_prefix/opt/dotfiles" ]]
  [[ ! -d "$trial_cellar" ]] || [[ -z "$(ls -A "$trial_cellar")" ]]
  ruby "$trial_dir/fixture.rb" remove "$trial_state" "$trial_prefix" "$trial_case"
  echo "DOTFILES_HOMEBREW_OWNERSHIP_PASSED case=$trial_kind"
done
# Leave local tap and temporary evidence to disposable VM teardown. On failure,
# also leave fixtures intact for diagnosis instead of guessing cleanup authority.
echo "DOTFILES_HOMEBREW_ACCEPTANCE_PASSED cases=3"
