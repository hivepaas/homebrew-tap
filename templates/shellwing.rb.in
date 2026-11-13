cask "shellwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "@version@"
  sha256 arm:   "@aarch64@",
         intel: "@x86_64@"

  url "https://github.com/hivepaas/shellwing/releases/download/v#{version}/shellwing_#{version}_macos_#{arch}.app.tar.gz"
  name "shellwing"
  desc "Fast, native SSH client"
  homepage "https://shellwing.app/"

  livecheck do
    url "https://raw.githubusercontent.com/hivepaas/shellwing/release/release.json"
    strategy :json do |json|
      json.dig("channels", "stable")&.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "shellwing.app"

  zap trash: [
    "~/Library/Application Support/shellwing",
    "~/Library/Caches/shellwing",
    "~/Library/Saved Application State/com.hivepaas.shellwing.savedState",
  ]
end
