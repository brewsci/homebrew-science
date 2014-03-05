require "formula"

class Gmcloser < Formula
  homepage "http://sourceforge.net/projects/gmcloser/"
  url "https://downloads.sourceforge.net/project/gmcloser/GMcloser-1.2.tar.gz"
  sha1 "7c3fdfc289a7f4469825f6eb7a6c773722b92754"

  def install
    doc.install "Manual_GMcloser.pdf"
    libexec.install Dir["*"]
    (bin/'gmcloser').write <<-EOS.undent
      #!/bin/sh
      set -eu
      exec #{libexec}/gmcloser "$@"
    EOS
  end

  test do
    system "#{bin}/gmcloser --help"
  end
end
