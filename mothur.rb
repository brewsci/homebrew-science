class Mothur < Formula
  desc "16s analysis software"
  homepage "http://www.mothur.org"
  url "https://github.com/mothur/mothur/archive/v1.38.1.1.tar.gz"
  sha256 "e0c29e144a73b083e24c4138c9e7eee5969ceeddc57bcab9eb4094d48ce5bf97"
  head "https://github.com/mothur/mothur.git"
  # tag "bioinformatics"
  # doi "10.1128/AEM.01541-09"

  depends_on "boost"

  def install
    boost = Formula["boost"]
    inreplace "Makefile", '"\"Enter_your_boost_library_path_here\""', boost.opt_lib
    inreplace "Makefile", '"\"Enter_your_boost_include_path_here\""', boost.opt_include
    system "make"
    bin.install "mothur", "uchime"
  end

  test do
    system "#{bin}/mothur", "-h"
    system "#{bin}/uchime", "--help"
  end
end
