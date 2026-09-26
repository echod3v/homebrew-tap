cask "lidon" do
  version "1.0.7"
  sha256 "b234181e8bce923c841e9e7e597a054ff51ed71083aae69c4c1d5b202e607733"

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
    # An upgrade quits LidOn. If it was running a moment ago, start it again so it can pick up where it left off
    # (a Mac running with the lid closed would otherwise go to sleep).
    state = File.expand_path("~/Library/Application Support/LidOn/state.json")
    if File.exist?(state) && Time.now - File.mtime(state) < 120
      system_command "/usr/bin/open", args: ["-g", "#{appdir}/LidOn.app"]
    end
  end

  uninstall quit: "dev.lidon.LidOn"

  zap trash: [
    "~/Library/Application Support/LidOn",
    "~/Library/Preferences/dev.lidon.LidOn.plist",
  ]
end
