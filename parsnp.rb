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
    url "https://github.com/marbl/parsnp/releases/download/v1.2/parsnp-OSX64-v1.2.tar.gz"
    sha256 "fe8992fb148541cc753670a151bab9ccbd62a23bdec8be9a9c69999e3ca9ff02"
  elsif OS.linux?
    url "https://github.com/marbl/parsnp/releases/download/v1.2/parsnp-Linux64-v1.2.tar.gz"
    sha256 "ec60bab2306005baca374cc84b4d4dd20dd124e7ea0eee88ec59d9e5a95ce548"
  end

  def install
    bin.install "parsnp"
    doc.install "README"
  end

  test do
    assert_match "recombination", shell_output("parsnp 2>&1", 2)
  end
end
