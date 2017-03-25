class Rapsearch2 < Formula
  desc "Reduced Alphabet based Protein similarity Search"
  homepage "https://rapsearch2.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/rapsearch2/RAPSearch2.24_64bits.tar.gz"
  version "2.24"
  sha256 "85db4573f4c768b6c3c73bb44ff2611ba48dc6c8d188feb40f44bf7c55de36ce"
  # tag "bioinformatics"
  # doi "10.1093/bioinformatics/btr595:"

  bottle do
    sha256 "9ac3cea477b5f6cb59f355527e0087abdfc8d9f79cdf8338a32e7dfcc109368a" => :el_capitan
    sha256 "f0ca7688f5aac5f23995b99c7f975770fbd74ce5033d23f23b44a9ac62a8ae77" => :yosemite
    sha256 "276f588874b3f84e33f861c597c29e2e26edd06ea863b3ffd1afbe80c9445f74" => :mavericks
    sha256 "3bcc1082a7c239d73969dbbebfa5c452b5d58fc428b3d5db972466d9c5176a9a" => :x86_64_linux
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
