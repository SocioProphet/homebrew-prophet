class SourceosDevtools < Formula
  desc "SourceOS developer and AI operator CLI"
  homepage "https://github.com/SourceOS-Linux/sourceos-devtools"
  url "https://github.com/SourceOS-Linux/sourceos-devtools.git", branch: "main"
  version "0.1.0-dev"

  depends_on "python@3.12"

  def install
    libexec.install Dir["*"]
    (bin/"sourceosctl").write <<~EOS
      #!/bin/bash
      exec "#{Formula["python@3.12"].opt_bin}/python3.12" "#{libexec}/bin/sourceosctl" "$@"
    EOS
  end

  test do
    system "#{bin}/sourceosctl", "--help"
    system "#{bin}/sourceosctl", "agent-machine", "mounts", "plan"
    system "#{bin}/sourceosctl", "office", "doctor"
  end
end
