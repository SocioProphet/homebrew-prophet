class ProphetCli < Formula
  include Language::Python::Virtualenv

  desc "Facade CLI for SocioProphet and SourceOS local tools"
  homepage "https://github.com/SocioProphet/prophet-cli"
  url "https://github.com/SocioProphet/prophet-cli.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/prophet", "--help"
    assert_match "required delegate not found", shell_output("#{bin}/prophet sourceos local-model doctor 2>&1", 127)
    assert_match "required delegate not found", shell_output("#{bin}/prophet sourceos office doctor 2>&1", 127)
  end
end
