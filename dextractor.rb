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
    sha256 "3e2b3c31fb5f30ec1cc3a32f372c963b9dacb9247fea41784e5420e4fbb5fdbe" => :el_capitan
    sha256 "c59bbb06630c8eb021c11400979f2e1034fe455d7f9337e6689aebb16a1243c3" => :yosemite
    sha256 "1749b5a6ab78de9d62a5c76738092c91bdf22af4a9ee8d18dfc63922e9583731" => :mavericks
    sha256 "9fd68ea0e17990569bd9c65741c722e58a38829d5c1b34c6f6645ec333372524" => :x86_64_linux
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
