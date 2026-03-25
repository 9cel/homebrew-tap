class Clickity < Formula
  desc "Mechanical keyboard click sounds for macOS"
  homepage "https://github.com/9cel/type"
  version "0.1.3"
  url "https://github.com/9cel/type/releases/download/v#{version}/clickity-#{version}-arm64.tar.gz"
  sha256 "d8ec5ee4d4bfb96ad774fef9f98e8eddb4797b83c6c990e5b29c5f26201fba54"
  license :public_domain

  depends_on :macos

  def install
    bin.install "clickity"
    bin.install "clickityd"

    libexec.install "ty"
    (lib/"ty").install Dir["lib/ty/*"]
    (lib/"clickity").install "libsoundio.dylib"
    (lib/"clickity").install "libyaml.dylib"

    (share/"clickity/sounds").install Dir["sounds/*"]

    inreplace bin/"clickityd", %r{^#!.*$}, "#!#{libexec}/ty"
    inreplace bin/"clickity", %r{^#!.*$}, "#!#{libexec}/ty"
  end

  service do
    run ["#{opt_prefix}/libexec/ty", "#{opt_prefix}/bin/clickityd"]
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
        Hit + then Cmd+Shift+G and paste: #{opt_prefix}/libexec/ty

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
