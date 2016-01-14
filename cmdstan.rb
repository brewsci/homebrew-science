class Cmdstan < Formula
  desc "Probabilistic programming for Bayesian inference"
  homepage "http://mc-stan.org/"
  # tag "math"
  url "https://github.com/stan-dev/cmdstan/releases/download/v2.9.0/cmdstan-2.9.0.tar.gz"
  sha256 "a9f2858caa5b55576da85ef31b4eae632c97837aa042514242a9aad7ada97121"

  bottle do
    cellar :any
    sha256 "a6c23277dcc15ce6c70f3b50b7e3cdc749d0b83139fb7de270e36564a70a6460" => :yosemite
    sha256 "0fac67e14fb25191104c09df25ca437d891104925f56aa307b0e650dc7d07b96" => :mavericks
    sha256 "336473380148fd20886c8fcb68538a4cbc77daa52c1a515d5bcb3f4793cfe1db" => :mountain_lion
  end

  depends_on "boost"
  depends_on "eigen"

  def install
    #
    # Before we build we need to change the make files since cmdstan builds more than binaries
    # into the bin dir. This is not how homebrew prefers things and we were recommended
    # by homebrew-science maintainers to change the makefiles to rather build from and to lib.
    # We need to change in 3 make files below.
    #

    # 1. We need to change make/command file so that lines with "bin/cmdstand" instead uses
    # "lib/cmdstan" and that the libstanc.a library has a lib instead of a bin path:
    inreplace "make/command" do |s|
      s.gsub! "bin/cmdstan/", "lib/cmdstan/"
      s.gsub! "bin/libstanc.a", "lib/libstanc.a"
    end

    # 2. We need to change make/libstan so that libstanc.a is referred to via a lib path instead of a
    # bin path:
    inreplace "make/libstan" do |s|
      s.gsub! "bin/libstanc.a", "lib/libstanc.a"
      s.gsub! "bin/stan/%.o", "lib/stan/%.o"
      s.gsub! "src/%.cpp=bin/%.o", "src/%.cpp=lib/%.o"
    end

    # 3. Several corresponding changes in the main makefile:
    inreplace "makefile" do |s|
      s.gsub! "LDLIBS_STANC = -Lbin", "LDLIBS_STANC = -Llib"
      s.gsub! "bin/%.o", "lib/%.o"
      s.gsub! "bin/stan/%.o :", "lib/stan/%.o :"
      s.gsub! "bin/libstanc.a", "lib/libstanc.a"
      s.gsub! "bin/%.d", "lib/%.d"
    end

    # Now we can build:
    system "make", "build"

    # And install and symlink the commands.
    bin.install "bin/stansummary"
    bin.install "bin/stanc"
    bin.install "bin/print" # Include it for now, it will be obsolete in cmdstan 3.0 but some people might still use it

    # Now install the lib dir with the built object and lib files. They are needed later when we
    # build executables for specific Stan models.
    lib.install Dir["lib/*"]

    # Install docs
    doc.install "CONTRIBUTING.md", "LICENSE", "README.md"

    # For the standard stan make system to work we also need the following files in prefix:
    prefix.install "src", "makefile", "make", "stan_2.9.0", "examples"
  end

  test do
    system "#{bin}/stanc", "--version"
    cp prefix/"examples/bernoulli/bernoulli.stan", "."
    system "#{bin}/stanc", "bernoulli.stan"
    system "make", "bernoulli_model.o", "CPPFLAGS=-I#{Formula["eigen"].include/"eigen3"} -I#{prefix}/stan_2.9.0/src -I#{prefix}/stan_2.9.0/lib/stan_math_2.9.0"
  end
end
