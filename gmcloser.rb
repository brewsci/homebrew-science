class Gmcloser < Formula
  homepage "https://sourceforge.net/projects/gmcloser/"
  url "https://downloads.sourceforge.net/project/gmcloser/GMcloser-1.5.1.tar.gz"
  sha256 "5f25d428a2530f2faa4af1858f9725945e95e6ebb55e43a0cfb4545b01508d0c"

  bottle do
    cellar :any
    sha256 "68f334e3619c2c63e0c0ab0aede877bbfabb190a23a5e17d785704f14b4e4c7b" => :yosemite
    sha256 "4a34cc424e51e845b9894258c6a69a94ccd80802573b0b404a34e40c3f10ce37" => :mavericks
    sha256 "9802f7b2488041b06e0a18513f48264a855c4600b69b75246fe6b9b6564999b3" => :mountain_lion
  end

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
