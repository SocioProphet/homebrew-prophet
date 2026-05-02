class AgentTerm < Formula
  include Language::Python::Virtualenv

  desc "Terminal-native Matrix-first ChatOps console for SourceOS multi-agent operations"
  homepage "https://github.com/SourceOS-Linux/agent-term"
  url "https://github.com/SourceOS-Linux/agent-term.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/agent-term", "--help"
    system "#{bin}/agent-term", "planes", "show", "prophet-workspace"
  end
end
