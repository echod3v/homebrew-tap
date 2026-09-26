cask "lidon" do
  version "1.0.0"
  sha256 "4350ccc3465801e720f9bff376541230398269aafb65b6b44e5d4b3b5698820f"

  url "https://github.com/echod3v/LidOn/releases/download/v#{version}/LidOn-#{version}.zip"
  name "LidOn"
  desc "Keep your MacBook and coding agents running with the lid closed"
  homepage "https://github.com/echod3v/LidOn"

  depends_on macos: ">= :sonoma"

  app "LidOn.app"
  binary "#{appdir}/LidOn.app/Contents/Helpers/lidon"

  # Free, unsigned app: remove the Gatekeeper quarantine attribute
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/LidOn.app"]
  end

  uninstall quit: "dev.lidon.LidOn"

  zap trash: [
    "~/Library/Application Support/LidOn",
    "~/Library/Preferences/dev.lidon.LidOn.plist",
  ]
end
