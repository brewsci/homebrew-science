class Mothur < Formula
  desc "16s analysis software"
  homepage "https://www.mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.39.5.tar.gz"
  sha256 "9f1cd691e9631a2ab7647b19eb59cd21ea643f29b22cde73d7f343372dfee342"
  revision 2
  head "https://github.com/mothur/mothur.git"
  # tag "bioinformatics"
  # doi "10.1128/AEM.01541-09"

  bottle do
    sha256 "a9c491f4967ccc0016077f39167dc2ff39418520d1606e5bd2537c6953edf7bb" => :sierra
    sha256 "2e916178a3e0bae42efa6da4063dc8a09e3fbb4d1c12fd6b4fa8fc7400f9e749" => :el_capitan
    sha256 "5e08fdc9fb96955a38a13b73d5ab3003d4cd70ccb5a24b2f1f176500e1b784f1" => :yosemite
    sha256 "a400dca2142813dee94254c6ee6180edb4b329076b72ea734007559be8b3bd0b" => :x86_64_linux
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
