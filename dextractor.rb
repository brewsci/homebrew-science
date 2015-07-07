class Dextractor < Formula
  desc "DEXTRACTOR: Bax File Decoder and Data Compressor"
  homepage "https://github.com/thegenemyers/DEXTRACTOR"
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
