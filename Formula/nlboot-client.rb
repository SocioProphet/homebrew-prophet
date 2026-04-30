# frozen_string_literal: true

# Formula for the SourceOS NLBoot signed boot/recovery client.
#
# NOTE: This formula targets Linux operator/recovery environments only.
#       Running `brew install nlboot-client` on macOS will print a clear
#       error and abort.  See the Linux-target note in the odie call below.
#
# SHA-256 PLACEHOLDERS: The sha256 values below must be replaced with the
#   actual artifact checksums before this formula is usable.  Run
#   `make update-nlboot-client VERSION=x.y.z` (or trigger the
#   update-nlboot-client GitHub Actions workflow) to update them
#   automatically from a published GitHub release.
class NlbootClient < Formula
  desc "SourceOS NLBoot signed boot/recovery client (Linux only)"
  homepage "https://github.com/SociOS-Linux/nlboot"
  version "0.1.0"
  license "MIT"

  # nlboot-client is a Linux-only tool: it drives kexec-based boot, live,
  # and recovery flows that have no equivalent on macOS.  The Apple Silicon
  # M2 adapter path in the upstream project is a dry-run evidence path, not
  # a native macOS install.
  on_macos do
    odie "nlboot-client targets Linux recovery/operator environments. " \
         "Use a Linux host, VM, or SourceOS devtools container."
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v#{version}/nlboot-client-nlboot-client-v#{version}-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "REPLACE_WITH_AARCH64_SHA256"
    else
      url "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v#{version}/nlboot-client-nlboot-client-v#{version}-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "REPLACE_WITH_X86_64_SHA256"
    end
  end

  def install
    bin.install "nlboot-client"
    doc.install "README.md"
    doc.install "RELEASE_AND_INSTALL.md" if File.exist?("RELEASE_AND_INSTALL.md")
    doc.install "release-manifest.json" if File.exist?("release-manifest.json")
  end

  test do
    assert_match "NLBoot", shell_output("#{bin}/nlboot-client --help")
  end
end
