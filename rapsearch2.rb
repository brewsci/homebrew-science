class Rapsearch2 < Formula
  desc "Reduced Alphabet based Protein similarity Search"
  homepage "https://rapsearch2.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rapsearch2/RAPSearch2.24_64bits.tar.gz"
  version "2.24"
  sha256 "85db4573f4c768b6c3c73bb44ff2611ba48dc6c8d188feb40f44bf7c55de36ce"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr595:"

  bottle do
    sha256 "28f6de891fc6aff968933ca60b388388f21784c2b2d02a65e922a10043fa1ed4" => :sierra
    sha256 "a351c44fba48a0f426dad0e7d3c281a94d28e8c421db5f9897c5672c89370e40" => :el_capitan
    sha256 "e3f97c8ac0450913443ca08444de06ed826107b0e3ee0f0f5a667b1d23c7d88c" => :yosemite
    sha256 "1e863c788f8b6758b6b6120f6f70adbab000734db3f1bee97409d613a8d45587" => :x86_64_linux
  end

  depends_on "boost"

  def install
    cd "Src" do
      # Fix error ld: library not found for -lboost_thread
      inreplace "Makefile", "-lboost_thread", "-lboost_thread-mt"
      boost = Formula["boost"]
      system "make", "INC=-I#{boost.opt_include}", "LIBS=-L#{boost.opt_lib}"
      bin.install "rapsearch", "prerapsearch"
    end
    doc.install "readme"
  end

  test do
    assert_match "threshold", shell_output("#{bin}/rapsearch 2>&1", 255)
  end
end
