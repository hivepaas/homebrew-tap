cask "packwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.0"
  sha256 arm:   "c075d47c5f494699516083ec9d9b91fb5eb2cbd2084e455b2ea62f8fa04870ed",
         intel: "91f096224ce471f1082c3363e939aa8a38a99dd704f68ee67586b1d67d1d7452"

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
