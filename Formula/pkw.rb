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
      url "https://github.com/hivepaas/packwing/releases/download/v0.3.0/pkw_0.3.0_macos_aarch64.tar.gz"
      sha256 "04bd03f54557cabacda55fe502b21dca6f7b8904da49610e05364a9c4a76822d"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.3.0/pkw_0.3.0_macos_x86_64.tar.gz"
      sha256 "c0f2aa4901413caa6c74dc682aac8b1e797a8d6403835ff50aa4ac1bf4bf6f41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v0.3.0/pkw_0.3.0_linux_aarch64.tar.gz"
      sha256 "3997eca6ee3ddb824cef1073160d4960ffd6e80958847739024d11ab42853deb"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.3.0/pkw_0.3.0_linux_x86_64.tar.gz"
      sha256 "2eaf262d9db24440533fb1edb09eb918581ff4d934b152e795baf10b8067ad13"
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
