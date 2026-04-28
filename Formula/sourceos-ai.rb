class SourceosAi < Formula
  desc "SourceOS on-device AI carry client and local service reference validator"
  homepage "https://github.com/SourceOS-Linux/sourceos-model-carry"
  url "https://github.com/SourceOS-Linux/sourceos-model-carry.git", branch: "main"
  version "0.1.0-dev"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"sourceos-ai", "./cmd/sourceos-ai"
  end

  test do
    system "#{bin}/sourceos-ai", "--version"
  end
end
