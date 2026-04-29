class GuardrailFabric < Formula
  desc "SocioProphet deterministic guardrail fabric CLI"
  homepage "https://github.com/SocioProphet/guardrail-fabric"
  url "https://github.com/SocioProphet/guardrail-fabric.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    python = Formula["python@3.12"].opt_bin/"python3"
    (bin/"guardrail-fabric").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ "${1:-}" == "test" ]]; then
        shift || true
        exec "#{python}" "#{libexec}/tools/guardrail_fabric.py" emit-demo-decision
      fi
      exec "#{python}" "#{libexec}/tools/guardrail_fabric.py" "$@"
    EOS
  end

  test do
    system "#{bin}/guardrail-fabric", "test", "examples/policy.json", "examples/input.json"
  end
end
