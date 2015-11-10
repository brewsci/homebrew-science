class Rapsearch2 < Formula
  desc "Reduced Alphabet based Protein similarity Search"
  homepage "http://rapsearch2.sourceforge.net/"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr595:"

  url "https://downloads.sourceforge.net/project/rapsearch2/RAPSearch2.23_64bits.tar.gz"
  version "2.23"
  sha256 "d3c1a8bf099ab0fa3f030283b004b9b874fb3104fd6a98b6a625e425580f23ef"

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
