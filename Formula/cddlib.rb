class Cddlib < Formula
  desc "Double description method for general polyhedral cones"
  homepage "https://www.inf.ethz.ch/personal/fukudak/cdd_home/"
  url "ftp://ftp.math.ethz.ch/users/fukudak/cdd/cddlib-094h.tar.gz"
  sha256 "fe6d04d494683cd451be5f6fe785e147f24e8ce3ef7387f048e739ceb4565ab5"
  # doi "math"
  # doi "10.1007/3-540-61576-8_77"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "6ea3afa298bb082bf41e0bfd90759b4b4f0ee02736473d0c08a3ee8f211179e4"
    sha256 cellar: :any, el_capitan:   "74ba8c0e0191e3f26d3d5bf8b28c0fabddeffade51a4ae8b07df5e0d72c144c4"
    sha256 cellar: :any, yosemite:     "831968c40009b3450ceffe1c4abd2734e566a724ff6795265db7719cf6ea596b"
    sha256 cellar: :any, x86_64_linux: "1359fc080fedfb2f956bb5114a47749031d3bdfbbd978edc119ebdeca1eb7507"
  end

  depends_on "gmp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/*"]
    pkgshare.install Dir["examples*"]
  end

  test do
    system "#{bin}/testshoot"
  end
end
