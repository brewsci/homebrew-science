class Dextractor < Formula
  desc "DEXTRACTOR: Bax File Decoder and Data Compressor"
  homepage "https://github.com/thegenemyers/DEXTRACTOR"
  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DEXTRACTOR/archive/V1.0.tar.gz"
  sha256 "5f45ab8944f857fc30b7a0e762fbdc63d9b61f3303412deee29d7580c53272bc"
  revision 4

  head "https://github.com/thegenemyers/DEXTRACTOR.git"

  bottle do
    cellar :any
    sha256 "946a3809d00028ffa2ac2ffbbfa6b16467deb5d0ad3035b68b1c1b72d4deef94" => :sierra
    sha256 "115769b29aa34f741e75195548cec5db072c51603b8e3f95851fd8e29b3bddef" => :el_capitan
    sha256 "946cbd098a294c8d2d752409d81112b8b183b4a51b497275dbae052c01234275" => :yosemite
    sha256 "484ffb0b47e7b55e5676c2725b6d00e4c5bc9a0acefdbb23989277145cdefe09" => :x86_64_linux
  end

  depends_on "hdf5"

  def install
    system "make"
    bin.install %w[dexqv dexta dextract undexqv undexta]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dextract 2>&1", 1)
  end
end
