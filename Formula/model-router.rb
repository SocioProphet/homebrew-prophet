class ModelRouter < Formula
  desc "SocioProphet governed model and service routing CLI"
  homepage "https://github.com/SocioProphet/model-router"
  url "https://github.com/SocioProphet/model-router.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    python = Formula["python@3.12"].opt_bin/"python3"
    (bin/"model-router").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      if [[ "${1:-}" == "route" ]]; then
        shift || true
        exec "#{python}" "#{libexec}/tools/model_router.py" emit-demo-decision
      fi
      exec "#{python}" "#{libexec}/tools/model_router.py" "$@"
    EOS
  end

  test do
    system "#{bin}/model-router", "route", "--task", "summarize", "--privacy", "local-first"
  end
end
