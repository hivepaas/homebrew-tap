cask "packwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.1.0"
  sha256 arm:   "470201684eff8ac86c249ca61740e0f7f83c34115a2763b4a9169ad55679ee37",
         intel: "93ff943a4759127789ecfeb199f05d7bb3bc7821382166fd58096a0211048b6b"

  url "https://github.com/hivepaas/packwing/releases/download/v#{version}/packwing_#{version}_macos_#{arch}.app.tar.gz"
  name "packwing"
  desc "File archiver that uses every core and opens archives safely"
  homepage "https://packwing.app"

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
