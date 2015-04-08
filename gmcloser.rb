class Gmcloser < Formula
  homepage "https://sourceforge.net/projects/gmcloser/"
  url "https://downloads.sourceforge.net/project/gmcloser/GMcloser-1.5.1.tar.gz"
  sha256 "5f25d428a2530f2faa4af1858f9725945e95e6ebb55e43a0cfb4545b01508d0c"

  def install
    doc.install "Manual_GMcloser_1.5.pdf"
    libexec.install Dir["*"]
    (bin/"gmcloser").write <<-EOS.undent
      #!/bin/sh
      set -eu
      exec #{libexec}/gmcloser "$@"
    EOS
  end

  test do
    system "#{bin}/gmcloser", "--help"
  end
end
