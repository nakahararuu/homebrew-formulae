# copied from https://github.com/koekeishiya/homebrew-formulae/blob/8e96736353534532b72edfaa3b2290413b34c042/yabai.rb

class Yabai < Formula
  desc "A tiling window manager for macOS based on binary space partitioning."
  homepage "https://github.com/koekeishiya/yabai"
  url "https://github.com/koekeishiya/yabai/releases/download/v5.0.9/yabai-v5.0.9.tar.gz"
  sha256 "9f9e86e48e0381f9016390c9b9d77d6539c1cf91deb9e8a3020db75259900a5e"
  head "https://github.com/koekeishiya/yabai.git"

  depends_on :macos => :big_sur

  def install
    man.mkpath

    if build.head?
      system "make", "-j1", "install"
    end

    bin.install "#{buildpath}/bin/yabai"
    (pkgshare/"examples").install "#{buildpath}/examples/yabairc"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
    man1.install "#{buildpath}/doc/yabai.1"
  end

  def caveats; <<~EOS
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/yabairc ~/.yabairc
      cp #{opt_pkgshare}/examples/skhdrc ~/.skhdrc

    If you want yabai to be managed by launchd (start automatically upon login):
      yabai --start-service

    When running as a launchd service logs will be found in:
      /tmp/yabai_<user>.[out|err].log

    If you are using the scripting-addition; remember to update your sudoers file:
      sudo visudo -f /private/etc/sudoers.d/yabai

    Build the configuration row by running:
      echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa"

    README: https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(latest-release)#configure-scripting-addition
    EOS
  end

  test do
    assert_match "yabai-v#{version}", shell_output("#{bin}/yabai --version")
  end
end
