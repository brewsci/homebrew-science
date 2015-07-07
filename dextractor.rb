class Dextractor < Formula
  desc "DEXTRACTOR: Bax File Decoder and Data Compressor"
  homepage "https://github.com/thegenemyers/DEXTRACTOR"
  bottle do
    cellar :any
    sha256 "63a69bf5d6de189043f484b1e91e62fa10359ac09f0a3fb3418cc565c41df585" => :yosemite
    sha256 "bae5327c44d5eb973a19c0212bbdf5ff381e3b00be8b138402fbe7184d7d178f" => :mavericks
    sha256 "f1c0d3ca01ad5b7901d9b387b6fdf992ae2d33c7ac31a60dacd867fb1ddb135e" => :mountain_lion
  end

  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DEXTRACTOR/archive/V1.0.tar.gz"
  sha256 "5f45ab8944f857fc30b7a0e762fbdc63d9b61f3303412deee29d7580c53272bc"

  head "https://github.com/thegenemyers/DEXTRACTOR.git"

  depends_on "hdf5"

  def install
    system "make"
    bin.install %w[dexqv dexta dextract undexqv undexta]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/dextract 2>&1", 1)
  end
end
