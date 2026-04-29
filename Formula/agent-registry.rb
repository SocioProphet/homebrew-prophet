class AgentRegistry < Formula
  desc "SocioProphet agent identity, tool grant, session authority, and revocation registry CLI"
  homepage "https://github.com/SocioProphet/agent-registry"
  url "https://github.com/SocioProphet/agent-registry.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    python = Formula["python@3.12"].opt_bin/"python3"
    (bin/"agent-registry").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      case "${1:-}" in
        list)
          find "#{libexec}/examples" -name '*.json' -print -exec cat {} \;
          ;;
        validate)
          exec "#{python}" "#{libexec}/tools/validate_agent_registry_examples.py"
          ;;
        *)
          exec "#{python}" "#{libexec}/tools/validate_agent_registry_examples.py" "$@"
          ;;
      esac
    EOS
  end

  test do
    system "#{bin}/agent-registry", "validate"
  end
end
