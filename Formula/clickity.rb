class Clickity < Formula
  desc "Mechanical keyboard click sounds for macOS"
  homepage "https://github.com/9cel/type"
  url "https://github.com/9cel/type/releases/download/v#{version}/clickity-#{version}-arm64.tar.gz"

  sha256 "PLACEHOLDER"
  version "0.1.0"
  license "MIT"

  depends_on :macos

  def install
    bin.install "clickity"
    bin.install "clickityd"

    (lib/"clickity").install "ty"
    (lib/"clickity/lib").install Dir["lib/*"]
    (lib/"clickity").install "libsoundio.dylib"
    (lib/"clickity").install "libyaml.dylib"

    (share/"clickity/sounds").install Dir["sounds/*"]

    inreplace bin/"clickityd", %r{^#!.*$}, "#!#{lib}/clickity/ty"
    inreplace bin/"clickity", %r{^#!.*$}, "#!#{lib}/clickity/ty"
  end

  service do
    run [opt_lib/"clickity/ty", opt_bin/"clickityd"]
    keep_alive true
    log_path var/"log/clickity.log"
    error_log_path var/"log/clickity.log"
    process_type :interactive
  end

  def caveats
    <<~EOS
      clickity requires Accessibility permission to listen for keystrokes.

      To grant permission:
        System Settings > Privacy & Security > Accessibility
        Add and enable: #{opt_lib}/clickity/ty

      Start the daemon:
        brew services start clickity

      Usage:
        clickity on                          Enable click sounds
        clickity off                         Disable click sounds
        clickity switch cherrymx-blue-abs    Switch sound profile
        clickity volume 80                   Set volume (0-100)
        clickity list                        List available profiles
        clickity status                      Show current state
    EOS
  end

  test do
    assert_match "clickity", shell_output("#{bin}/clickity --help", 1)
  end
end
