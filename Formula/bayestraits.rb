class Bayestraits < Formula
  desc "Trait evolution on phylogenies"
  homepage "http://www.evolution.rdg.ac.uk/BayesTraitsV3/BayesTraitsV3.html"
  url "http://www.evolution.rdg.ac.uk/BayesTraitsV3/Files/BayesTraitsV3-src.tar.gz"
  version "3.0"
  sha256 "6226afdac2aa93e49b54ffa7f77dc0107ee5fbfa0e8df92abef9d8aaacfb3828"
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:       "40298773f30495810c9a3de313bbf39fc0a4ce8dc6d3842a8ace1323fc529661"
    sha256 cellar: :any, el_capitan:   "c7866c39638a21127c14ca094e4de77215724321bb09e7ee134ac5b453769257"
    sha256 cellar: :any, yosemite:     "101a38c0377f79135651bc8c4e5f430ca3db68f2afcba00f3d2600b4e5bc3479"
    sha256 cellar: :any, x86_64_linux: "5748d8787f2d8a201861365d804a63031b82f0d5cfbb780cf89e5797023d8293"
  end

  option "with-openmp", "Build a threaded version with openmp"

  depends_on "gsl"
  depends_on "nlopt"
  depends_on "lapack" unless OS.mac?

  needs :openmp if build.with? "openmp"

  def install
    args = Dir["*.c"]
    args += %w[-O3 -lm -lgsl -lgslcblas -lnlopt]
    args += %w[-DOPENMP_THR -fopenmp] if build.with? "openmp"
    args += if OS.mac?
      %w[-framework Accelerate]
    else
      # nlopt links against the C++ stdlib on Linux
      %w[-llapack -lstdc++]
    end

    system ENV.cc, *args, "-o", "bayestraits"
    bin.install "bayestraits"
  end

  test do
    system "echo '\n' | #{bin}/bayestraits"
  end
end
