# frozen_string_literal: true

# Release formula template for guardrail-fabric
# ==============================================
# Copy this file to Formula/guardrail-fabric@__VERSION__.rb and replace every
# __PLACEHOLDER__ token with the real value from the official GitHub Release.
#
# Required inputs
# ---------------
#   __VERSION__      Semantic version string, e.g. "1.2.3"
#   __URL__          Download URL of the release tarball (from GitHub Releases)
#   __SHA256__       SHA-256 checksum of the release tarball
#   __SBOM_URL__     Download URL of the SBOM artifact attached to the same release
#   __SBOM_SHA256__  SHA-256 checksum of the SBOM artifact
#
# Do NOT invent URLs or checksums.  Obtain them from the official release page:
#   https://github.com/SocioProphet/guardrail-fabric/releases
#
# Provenance / SBOM
# -----------------
# Each stable release must ship a CycloneDX SBOM and a cosign provenance
# attestation.  Record the SBOM artifact in the commented-out resource block
# below, and verify the provenance attestation out-of-band before publishing.

class GuardrailFabricRelease < Formula
  desc "SocioProphet deterministic guardrail fabric CLI"
  homepage "https://github.com/SocioProphet/guardrail-fabric"
  url "__URL__"
  sha256 "__SHA256__"
  version "__VERSION__"
  license "MIT"

  # Uncomment and fill in when creating the release formula:
  # resource "sbom" do
  #   url "__SBOM_URL__"
  #   sha256 "__SBOM_SHA256__"
  # end

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    python = Formula["python@3.12"].opt_bin/"python3"
    (bin/"guardrail-fabric").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      exec "#{python}" "#{libexec}/tools/guardrail_fabric.py" "$@"
    EOS
  end

  test do
    assert_match "guardrail-fabric", shell_output("#{bin}/guardrail-fabric --version 2>&1")
  end
end
