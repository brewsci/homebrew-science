class Mothur < Formula
  desc "16s analysis software"
  homepage "http://www.mothur.org"
  url "https://github.com/mothur/mothur/archive/v1.39.0.tar.gz"
  sha256 "b72d8930c21a797cebed8267390b63efe7988fdaa3734babfcc5fb9e58a9c895"
  head "https://github.com/mothur/mothur.git"
  # tag "bioinformatics"
  # doi "10.1128/AEM.01541-09"

  bottle do
    sha256 "62d736a1aa21e1d15f7ced134c7672e12f527fd228aa73c4b9ff0fc045607e37" => :sierra
    sha256 "5af142d0c836d13e80218fec004764f64659896cd5a8792b0d885305d86cfdd6" => :el_capitan
    sha256 "a06890a543f796d9faf9b66fce1a191dbd59dabc068401a358b5d6313fa884bf" => :yosemite
  end

  depends_on "boost"
  depends_on "readline" unless OS.mac?

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
