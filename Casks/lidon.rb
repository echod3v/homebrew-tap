cask "lidon" do
  version "1.0.1"
  sha256 "2b23c7bebd339708f1c4585be010a3d679fbca46e1912808c8ba57b076f9cacd"

  url "https://github.com/echod3v/LidOn/releases/download/v#{version}/LidOn-#{version}.zip"
  name "LidOn"
  desc "Keep your MacBook and coding agents running with the lid closed"
  homepage "https://github.com/echod3v/LidOn"

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
