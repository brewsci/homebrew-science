class Bayestraits < Formula
  desc "trait evolution on phylogenies"
  homepage "http://www.evolution.rdg.ac.uk/BayesTraitsV3/BayesTraitsV3.html"
  url "http://www.evolution.rdg.ac.uk/BayesTraitsV3/Files/BayesTraitsV3-src.tar.gz"
  version "3.0"
  sha256 "6226afdac2aa93e49b54ffa7f77dc0107ee5fbfa0e8df92abef9d8aaacfb3828"

  option "with-openmp", "Build a threaded version with openmp"

  depends_on "nlopt"
  depends_on "gsl"
  depends_on "lapack" unless OS.mac?

  needs :openmp if build.with? "openmp"

  def install
    args = Dir["*.c"]
    args += %w[-O3 -lm -lgsl -lgslcblas -lnlopt]
    args += %w[-DOPENMP_THR -fopenmp] if build.with? "openmp"
    if OS.mac?
      args += %w[-framework Accelerate]
    else
      # nlopt links against the C++ stdlib on Linux
      args += %w[-llapack -lstdc++]
    end

    system ENV.cc, *args, "-o", "bayestraits"
    bin.install "bayestraits"
  end

  test do
    system "echo '\n' | #{bin}/bayestraits"
  end
end
