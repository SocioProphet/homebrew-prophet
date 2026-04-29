class ModelGovernanceLedger < Formula
  desc "SocioProphet model governance evidence, promotion, and rollback ledger CLI"
  homepage "https://github.com/SocioProphet/model-governance-ledger"
  url "https://github.com/SocioProphet/model-governance-ledger.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    python = Formula["python@3.12"].opt_bin/"python3"
    (bin/"model-governance-ledger").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      case "${1:-}" in
        validate)
          exec "#{python}" "#{libexec}/tools/validate_ledger_examples.py"
          ;;
        records)
          find "#{libexec}/examples" -name '*.json' -print -exec cat {} \;
          ;;
        *)
          exec "#{python}" "#{libexec}/tools/validate_ledger_examples.py" "$@"
          ;;
      esac
    EOS
  end

  test do
    system "#{bin}/model-governance-ledger", "validate"
  end
end
