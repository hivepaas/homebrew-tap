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
      url "https://github.com/hivepaas/packwing/releases/download/v0.4.0/pkw_0.4.0_macos_aarch64.tar.gz"
      sha256 "a581394bf5d0d8985d8fc6bcccbe8acca29b98861c5838d6b7c35512ac60c3cb"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.4.0/pkw_0.4.0_macos_x86_64.tar.gz"
      sha256 "8fb7171a0c3cda6941e007f8a8ec47892a5c246b25be97336d4ddc10ad6e0d0d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v0.4.0/pkw_0.4.0_linux_aarch64.tar.gz"
      sha256 "360c6a857e9fc7750dc6cea615741f2aad7108d5c860980a83a0afb0ab98daa7"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.4.0/pkw_0.4.0_linux_x86_64.tar.gz"
      sha256 "a8e491928de88dc076584153dca92c85ce40c0d3a846e095b7d6b103ef8ecdce"
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
