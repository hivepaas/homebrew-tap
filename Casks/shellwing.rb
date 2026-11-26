cask "shellwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.4.0"
  sha256 arm:   "e18843d7329323a6554ba866786325726fc8ee538910709ae52b1f4de35558f0",
         intel: "00e649b55818299dbd024ec7a29677d22d220768afd3d6a36457da9874f44104"

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
