cask "lidon" do
  version "1.0.2"
  sha256 "331a7c3f779e6245f04996315199beee3b8f094aa210141e72ffe40f45c48b3a"

  url "https://github.com/jayden0903/LidOn/releases/download/v#{version}/LidOn-#{version}.zip"
  name "LidOn"
  desc "Keep your MacBook and coding agents running with the lid closed"
  homepage "https://github.com/jayden0903/LidOn"

  depends_on macos: :sonoma

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
