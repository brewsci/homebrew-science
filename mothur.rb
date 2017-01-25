class Mothur < Formula
  desc "16s analysis software"
  homepage "http://www.mothur.org"
  url "https://github.com/mothur/mothur/archive/v1.39.0.tar.gz"
  sha256 "b72d8930c21a797cebed8267390b63efe7988fdaa3734babfcc5fb9e58a9c895"
  head "https://github.com/mothur/mothur.git"
  # tag "bioinformatics"
  # doi "10.1128/AEM.01541-09"

  bottle do
    sha256 "41c366e68b69f005fe514abb4198e9ebcbcd197e91c9aabdb15209b2c1de1674" => :sierra
    sha256 "0e0db35f1786a9ac237028c68aa59c50638af478f1ff12b1e01cb3a2a662b75f" => :el_capitan
    sha256 "1e9cf0e95c35030a84d0792dab3d9525059790e290e0eb244f2fd0c108aaed5a" => :yosemite
    sha256 "5218eeabcab002f56b6cfc2481be948481f429d3e098747b941cf99d152a2688" => :x86_64_linux
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
