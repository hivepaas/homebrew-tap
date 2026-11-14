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
      url "https://github.com/hivepaas/packwing/releases/download/v0.2.0/pkw_0.2.0_macos_aarch64.tar.gz"
      sha256 "04bc9e97c19129310c942d73c16f514ed1c8b0ceae952d4276b49f57969dd530"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.2.0/pkw_0.2.0_macos_x86_64.tar.gz"
      sha256 "894c6aacb74ead83ca2ff7dac35844d2bb32cea4a36d9781a25a4a53a5b4c91f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v0.2.0/pkw_0.2.0_linux_aarch64.tar.gz"
      sha256 "294867380ce596274b3c1c337b8b61e5e2b664eb0a5286a39dc8f22ffd4e453c"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.2.0/pkw_0.2.0_linux_x86_64.tar.gz"
      sha256 "44085f65a3226eb818640c0b1068e04eb91aaaae2386254b31ee701cfb21af6f"
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
