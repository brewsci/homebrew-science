class Rapsearch2 < Formula
  desc "Reduced Alphabet based Protein similarity Search"
  homepage "https://rapsearch2.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rapsearch2/RAPSearch2.24_64bits.tar.gz"
  version "2.24"
  sha256 "85db4573f4c768b6c3c73bb44ff2611ba48dc6c8d188feb40f44bf7c55de36ce"
  revision 1
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr595"

  bottle do
    sha256 "0d3755d6140e349a50b46358fbccf6d2b7e688c8e9a14037e6e67c4c0c5e3daf" => :sierra
    sha256 "0cecc678b37835b0c9710a7373a8f473950bb486381d30a23f84013155e76aca" => :el_capitan
    sha256 "e5a398c890866e84a52376608b1bf5d89b5aa8d01294be819799bb0fd6af8f9d" => :yosemite
    sha256 "05592fb9c9ac718c336bbd4b52127cb92340848164e1ac7b8f3e4c7afea86dab" => :x86_64_linux
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
