class Cmdstan < Formula
  desc "Probabilistic programming language for Bayesian inference"
  homepage "http://mc-stan.org/"
  # tag "math"

  url "https://github.com/stan-dev/cmdstan/releases/download/v2.7.0/cmdstan-2.7.0.tar.gz"
  sha256 "8f8f119a88327a7cef9829cb593a1d726a65c6bc37cc85ef11f5442add31d9e1"

  depends_on "boost"
  depends_on "eigen"

  def install
    system "make", "build"
    bin.install "bin/print" => "stansummary"
    bin.install "bin/stanc"
    doc.install "CONTRIBUTING.md", "LICENSE", "README.md", "examples"
    include.install "stan/src/stan"
    (include/"stan").install Dir["stan/lib/stan_math_*/stan/*"]
  end

  test do
    system "#{bin}/stanc", "--version"
    cp doc/"examples/bernoulli/bernoulli.stan", "."
    system "#{bin}/stanc", "bernoulli.stan"
    system "make", "bernoulli_model.o", "CPPFLAGS=-I#{Formula["eigen"].include/"eigen3"}"
  end
end
