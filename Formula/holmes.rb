class Holmes < Formula
  desc "SocioProphet language intelligence fabric CLI"
  homepage "https://github.com/SocioProphet/holmes"
  url "https://github.com/SocioProphet/holmes.git", branch: "main"
  version "0.1.0-dev"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"holmes", "./cmd/holmes"
  end

  test do
    system "#{bin}/holmes", "--version"
  end
end
