cask "packwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.0"
  sha256 arm:   "ae9fb1f50c494ddd485abab9289ef8a81357deb953a9bea5b2f78fb62eb3430e",
         intel: "fc7fb8eeb79409f6740a8345e837e5ed3c8943d18a59c59ac6561fa58924cf80"

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
