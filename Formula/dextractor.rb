class Dextractor < Formula
  desc ": Bax File Decoder and Data Compressor"
  homepage "https://github.com/thegenemyers/DEXTRACTOR"
  # doi "10.1007/978-3-662-44753-6_5"
  # tag "bioinformatics"

  url "https://github.com/thegenemyers/DEXTRACTOR/archive/V1.0.tar.gz"
  sha256 "5f45ab8944f857fc30b7a0e762fbdc63d9b61f3303412deee29d7580c53272bc"
  revision 4

  head "https://github.com/thegenemyers/DEXTRACTOR.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "da723458ae41c38318d09f70d72caade2ca997eb714a53b7631c3469e9c00e3a"
    sha256 cellar: :any, el_capitan:   "d269e8f8e1c7fb1cb9b3c1ebcad2fbf02ed207e9ee77fbff7a0dc45c9f6c0089"
    sha256 cellar: :any, yosemite:     "aa4d5bbf96dcace4d0173ef7345a00ff53f06f3b7eff0dea5e10bc04b3dfb516"
    sha256 cellar: :any, x86_64_linux: "4da648a7b6463be7f11f7618cb9507722ae96e99de483958a7b677e62d98336f"
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
