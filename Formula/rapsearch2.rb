class Rapsearch2 < Formula
  desc "Reduced Alphabet based Protein similarity Search"
  homepage "https://rapsearch2.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rapsearch2/RAPSearch2.24_64bits.tar.gz"
  version "2.24"
  sha256 "85db4573f4c768b6c3c73bb44ff2611ba48dc6c8d188feb40f44bf7c55de36ce"
  revision 3
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr595"

  bottle :disable, "needs to be rebuilt with latest boost"

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
