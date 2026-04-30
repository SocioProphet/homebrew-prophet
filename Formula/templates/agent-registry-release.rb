# frozen_string_literal: true

# Release formula template for agent-registry
# ============================================
# Copy this file to Formula/agent-registry@__VERSION__.rb and replace every
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
#   https://github.com/SocioProphet/agent-registry/releases
#
# Provenance / SBOM
# -----------------
# Each stable release must ship a CycloneDX SBOM and a cosign provenance
# attestation.  Record the SBOM artifact in the commented-out resource block
# below, and verify the provenance attestation out-of-band before publishing.

class AgentRegistryRelease < Formula
  desc "SocioProphet agent identity, tool grant, session authority, and revocation registry CLI"
  homepage "https://github.com/SocioProphet/agent-registry"
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
    (bin/"agent-registry").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      exec "#{python}" "#{libexec}/tools/agent_registry.py" "$@"
    EOS
  end

  test do
    assert_match "agent-registry", shell_output("#{bin}/agent-registry --version 2>&1")
  end
end
