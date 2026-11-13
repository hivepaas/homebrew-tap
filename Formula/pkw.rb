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
      url "https://github.com/hivepaas/packwing/releases/download/v0.1.0/pkw_0.1.0_macos_aarch64.tar.gz"
      sha256 "3972f3eb8dfb1b97061243446fdc58f7876dbd248fa240be1d54ae84f63b1175"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.1.0/pkw_0.1.0_macos_x86_64.tar.gz"
      sha256 "3fb30811479a55e31cb89b40e73ad3b591bc98abad882a2dc3aac84bc72399c0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/hivepaas/packwing/releases/download/v0.1.0/pkw_0.1.0_linux_aarch64.tar.gz"
      sha256 "bc73c7f867fae033ae9db6e029fc0281edbd609ecb3d8934cdd53d46495d0de9"
    end
    on_intel do
      url "https://github.com/hivepaas/packwing/releases/download/v0.1.0/pkw_0.1.0_linux_x86_64.tar.gz"
      sha256 "e8bc3cc5d1237522b069371ab4107fb4321a6de12322ce3709bff65a79e5eaec"
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
