class Parsnp < Formula
  homepage "https://github.com/marbl/parsnp"
  # tag "bioinformatics"
  # doi "10.1186/s13059-014-0524-x"

  head "https://github.com/marbl/parsnp.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    revision 1
    sha256 "17db88e2d32cf5305289c6f01efc7c5aa84322b320c88a5fb3b1edb08af38d66" => :yosemite
    sha256 "2af68fb53847adc2dfaccae9de21298f158e818afb2672c64d0b092298440030" => :mavericks
    sha256 "a29141c0299d5fc72be88c9b29b1501ecba66b29d79e3c756d70a13c1bd1bac2" => :mountain_lion
  end

  if OS.mac?
    url "https://github.com/marbl/parsnp/releases/download/v1.1/parsnp-OSX64-v1.1.tar.gz"
    sha256 "e11dd913b9a4ba1a87c29fd38b101119ce0dda3180fdc4ec0382bc4e8438366d"
  elsif OS.linux?
    url "https://github.com/marbl/parsnp/releases/download/v1.1/parsnp-Linux64-v1.1.tar.gz"
    sha256 "d530b2be99b9a21acaa4e66e00adc7e1bd602440c67e86c73b8821e5327e8813"
  end

  def install
    bin.install "parsnp"
  end

  test do
    system "#{bin}/parsnp", "-h"
  end
end
