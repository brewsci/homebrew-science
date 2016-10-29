class Dextractor < Formula
  desc "DEXTRACTOR: Bax File Decoder and Data Compressor"
  homepage "https://github.com/thegenemyers/DEXTRACTOR"
  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DEXTRACTOR/archive/V1.0.tar.gz"
  sha256 "5f45ab8944f857fc30b7a0e762fbdc63d9b61f3303412deee29d7580c53272bc"
  revision 2

  head "https://github.com/thegenemyers/DEXTRACTOR.git"

  bottle do
    cellar :any
    sha256 "6d1925f18492d7cd01bec5bbdd73b2cc078b87ef371d3e0503eff8c8f61a3951" => :el_capitan
    sha256 "4ff0ca86c904a2d6e6046c519ab928b9f8bb1a72568bd4da9b37a14fbd3afd44" => :yosemite
    sha256 "1637264ec2a73e57f7d019497a319bc28f4518bcaab6d0b2c257a8990e2cbec1" => :mavericks
    sha256 "2c26f359eedd68a1b62476f0a64e323f45f629f65b3cedb89713bb7616d23946" => :x86_64_linux
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
