cask "packwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "@version@"
  sha256 arm:   "@app_aarch64@",
         intel: "@app_x86_64@"

  url "https://github.com/hivepaas/packwing/releases/download/v#{version}/packwing_#{version}_macos_#{arch}.app.tar.gz"
  name "packwing"
  desc "File archiver that uses every core and opens archives safely"
  homepage "https://packwing.app/"

  livecheck do
    url "https://raw.githubusercontent.com/hivepaas/packwing/release/release.json"
    strategy :json do |json|
      json.dig("channels", "stable")&.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Packwing.app"

  zap trash: [
    "~/Library/Application Support/packwing",
    "~/Library/Caches/packwing",
    "~/Library/Saved Application State/com.hivepaas.packwing.savedState",
  ]
end
