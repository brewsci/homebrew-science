class Cmdstan < Formula
  desc "Probabilistic programming for Bayesian inference"
  homepage "http://mc-stan.org/"
  # tag "math"
  url "https://github.com/stan-dev/cmdstan/releases/download/v2.14.0/cmdstan-2.14.0.tar.gz"
  sha256 "4dfe78e4682cd84d77455b150337cc96f2c911d158085e10b8b98c802cbf90e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6147aca5d02f746846628e610539b92c52fc884f55d2dff59652e572de33f541" => :sierra
    sha256 "345273c4d9296d214b7b779dfeec351415774ad6fc43f76fc9bb781374f46e68" => :el_capitan
    sha256 "bf4f3afa6ee2b1c01169720011b638257590e27b92e37fcd536c5dac31d2c0ed" => :yosemite
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

    # For the standard stan make system to work we also need the following files in prefix:
    prefix.install "src", "makefile", "make", "stan_#{version}", "examples"
  end

  test do
    system bin/"stanc", "--version"
    cp prefix/"examples/bernoulli/bernoulli.stan", testpath
    system bin/"stanc", "bernoulli.stan"
    math = prefix/"stan_#{version}/lib/stan_math_#{version}"
    libraries = File.read(math/"make/libraries")
    cvodes = libraries.match(%r{(lib\/cvodes_([0-9\.]+))\n})[1]
    ENV["CPPFLAGS"] = %W[-I#{prefix}/stan_#{version}/src
                         -I#{math} -I#{math}/#{cvodes}/include
                         -I#{Formula["eigen"].opt_include/"eigen3"}].join(" ")
    system "make", "bernoulli_model.o"
  end
end
