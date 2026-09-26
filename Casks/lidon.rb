cask "lidon" do
  version "1.0.8"
  sha256 "943c347a7702577b966b614e12696111ba39ef530f730c44fbda0a82f637aaaa"

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
    # One-time admin setup (asks for your password): lets LidOn toggle `pmset disablesleep` while it runs with the
    # lid closed, so plugging in a charger or display doesn't put the Mac to sleep. Allows only those two commands.
    unless File.exist?("/etc/sudoers.d/lidon")
      system_command "#{appdir}/LidOn.app/Contents/Helpers/lidon",
                     args: ["system-setup", "--user", ENV.fetch("USER")],
                     sudo: true
    end
    # An upgrade quits LidOn. If it was running a moment ago, start it again so it can pick up where it left off
    # (a Mac running with the lid closed would otherwise go to sleep).
    state = File.expand_path("~/Library/Application Support/LidOn/state.json")
    if File.exist?(state) && Time.now - File.mtime(state) < 120
      system_command "/usr/bin/open", args: ["-g", "#{appdir}/LidOn.app"]
    end
  end

  uninstall quit:   "dev.lidon.LidOn",
            delete: "/etc/sudoers.d/lidon"

  zap trash: [
    "~/Library/Application Support/LidOn",
    "~/Library/Preferences/dev.lidon.LidOn.plist",
  ]
end
