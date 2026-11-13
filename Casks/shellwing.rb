cask "shellwing" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.2.1"
  sha256 arm:   "3ceecd7f723f42290e55ab3923bc396899c6e7626565fce12040ec66e941bdd1",
         intel: "bc3ebf9c4c28e35b506010165514a5a90de554d6dd7d9367f156850cb966975b"

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
