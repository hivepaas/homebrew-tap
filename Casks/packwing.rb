cask "packwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.3.0"
  sha256 arm:   "22923ee78f054d3b51806c1453c108fb12e0565b20debdfb1cd5b07e30fb80d9",
         intel: "7373f80ccec7f155e0fd6be58cc3d6fd9e6b1d42f4a887acecd17bd94f1dd40e"

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
