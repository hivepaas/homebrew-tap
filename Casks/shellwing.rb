cask "shellwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.3.0"
  sha256 arm:   "bca79a9eedd5df58353e7576998a34964f60edf0d71f045c70f200b8dd4922f0",
         intel: "dee2214bd9fcc4807b79f8d3e5cc525d8524d5cbb930e021c3a196f0dea80644"

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
