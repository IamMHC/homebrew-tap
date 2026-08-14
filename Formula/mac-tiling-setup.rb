class MacTilingSetup < Formula
  desc "Keyboard-driven tiling desktop for macOS: AeroSpace, SketchyBar, JankyBorders"
  homepage "https://github.com/IamMHC/mac-tiling-setup"
  url "https://github.com/IamMHC/mac-tiling-setup/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "42bf36c1c99594ddaf1a618bb4fcedac96f1ed6fde4595c3fd39e55ae121e935"
  license "MIT"

  depends_on "felixkratz/formulae/borders"
  depends_on "felixkratz/formulae/sketchybar"
  depends_on "ical-buddy"
  depends_on macos: :ventura

  # Casks can't be formula dependencies; the setup command installs them.

  def install
    libexec.install Dir["*"]
    chmod 0755, Dir[libexec/"*.sh"]

    # Wrapper, not a symlink: install.sh resolves its own dir for templates.
    (bin/"mac-tiling-setup").write <<~SH
      #!/bin/bash
      exec "#{libexec}/install.sh" "$@"
    SH

    (bin/"mac-tiling-setup-defaults").write <<~SH
      #!/bin/bash
      exec "#{libexec}/macos-defaults.sh" "$@"
    SH
  end

  def caveats
    <<~EOS
      Nothing has been written to your home directory yet.

      To apply the configs (existing ones are backed up first):
        mac-tiling-setup

      Then grant Accessibility to AeroSpace and QUIT AND REOPEN it. Its key
      listener only attaches at launch, so permission granted to a running app
      leaves every binding dead while the app appears to work.

      Optional macOS tweaks (hidden menu bar, shared Spaces, fast key repeat):
        mac-tiling-setup-defaults

      Requires Xcode command line tools for the calendar renderer:
        xcode-select --install
    EOS
  end

  test do
    # README/LICENSE get relocated to the prefix root.
    assert_predicate bin/"mac-tiling-setup", :executable?
    assert_predicate libexec/"install.sh", :executable?
    assert_match "mode.main.binding", (libexec/"aerospace/aerospace.toml").read
  end
end
