class Pkw < Formula
  desc "Fast, safe command-line archiver: ZIP, 7z, RAR, tar and more"
  homepage "https://packwing.app/"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v@version@/pkw_@version@_macos_aarch64.tar.gz"
      sha256 "@macos_aarch64@"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v@version@/pkw_@version@_macos_x86_64.tar.gz"
      sha256 "@macos_x86_64@"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v@version@/pkw_@version@_linux_aarch64.tar.gz"
      sha256 "@linux_aarch64@"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v@version@/pkw_@version@_linux_x86_64.tar.gz"
      sha256 "@linux_x86_64@"
    end
  end

  def install
    bin.install "pkw"
    man1.install Dir["man/*.1"]
    bash_completion.install "completions/pkw.bash" => "pkw"
    zsh_completion.install "completions/_pkw"
    fish_completion.install "completions/pkw.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pkw --version")

    (testpath/"hello.txt").write "hello from Homebrew"
    system bin/"pkw", "create", "hello.zip", "hello.txt"
    rm "hello.txt"
    system bin/"pkw", "extract", "hello.zip"
    assert_equal "hello from Homebrew", (testpath/"hello/hello.txt").read
  end
end
