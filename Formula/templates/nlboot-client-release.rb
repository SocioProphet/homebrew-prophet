# frozen_string_literal: true

# Release formula template for nlboot-client
# ===========================================
# Copy this file to Formula/nlboot-client@__VERSION__.rb and replace every
# __PLACEHOLDER__ token with the real value from the official GitHub Release.
#
# nlboot-client targets Linux operator/recovery environments only.
# It ships separate tarballs for x86_64 and aarch64.
#
# Required inputs
# ---------------
#   __VERSION__       Semantic version string, e.g. "0.1.0"
#   __X86_URL__       Download URL of the x86_64 release tarball
#   __X86_SHA256__    SHA-256 checksum of the x86_64 release tarball
#   __ARM_URL__       Download URL of the aarch64 release tarball
#   __ARM_SHA256__    SHA-256 checksum of the aarch64 release tarball
#   __SBOM_URL__      Download URL of the SBOM artifact attached to the same release
#   __SBOM_SHA256__   SHA-256 checksum of the SBOM artifact
#
# Do NOT invent URLs or checksums.  Obtain them from the official release page:
#   https://github.com/SociOS-Linux/nlboot/releases
#
# Provenance / SBOM
# -----------------
# Each stable release must ship a CycloneDX SBOM and a cosign provenance
# attestation.  Record the SBOM artifact in the commented-out resource block
# below, and verify the provenance attestation out-of-band before publishing.

class NlbootClientRelease < Formula
  desc "SourceOS NLBoot signed boot/recovery client (Linux only)"
  homepage "https://github.com/SociOS-Linux/nlboot"
  version "__VERSION__"
  license "MIT"

  # nlboot-client targets Linux recovery/operator environments only.
  # It drives kexec-based boot, live, and recovery flows that have no
  # equivalent on macOS.
  on_macos do
    odie "nlboot-client targets Linux recovery/operator environments. " \
         "Use a Linux host, VM, or SourceOS devtools container."
  end

  on_linux do
    if Hardware::CPU.arm?
      url "__ARM_URL__"
      sha256 "__ARM_SHA256__"
    else
      url "__X86_URL__"
      sha256 "__X86_SHA256__"
    end
  end

  # Uncomment and fill in when creating the release formula:
  # resource "sbom" do
  #   url "__SBOM_URL__"
  #   sha256 "__SBOM_SHA256__"
  # end

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
