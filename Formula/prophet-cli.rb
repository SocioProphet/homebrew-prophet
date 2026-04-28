class ProphetCli < Formula
  desc "Facade CLI for SocioProphet, SourceOS, Holmes, and the functional AI product suite"
  homepage "https://github.com/SocioProphet/prophet-cli"
  url "https://github.com/SocioProphet/prophet-cli.git", branch: "main"
  version "0.1.0-dev"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"prophet", "./cmd/prophet"
  end

  test do
    system "#{bin}/prophet", "--help"
  end
end
