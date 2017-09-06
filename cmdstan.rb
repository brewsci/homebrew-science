class Cmdstan < Formula
  desc "Probabilistic programming for Bayesian inference"
  homepage "http://mc-stan.org/"
  # tag "math"
  url "https://github.com/stan-dev/cmdstan/releases/download/v2.17.0/cmdstan-2.17.0.tar.gz"
  sha256 "72194e91ae24e0c58e51a7db09a77fd759e78d41f4fb6f0b1f8be7b9ef235eb1"

  bottle do
    cellar :any_skip_relocation
    sha256 "9abbf30514d05f5307fa558ec1556ea09b0cb5e8811a23cbd966cf4386452547" => :sierra
    sha256 "8284278e3f42523c766c6275ef1f6fadb4169d07696113f66256218f8dc6015b" => :el_capitan
    sha256 "c1799f1b87ee2f89021feed16844d2c9d0a2f40df203986024d54ace3bf2ac07" => :yosemite
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
    prefix.install "src", "makefile", "make", "stan", "examples"
  end

  test do
    system bin/"stanc", "--version"
    cp prefix/"examples/bernoulli/bernoulli.stan", testpath
    system bin/"stanc", "bernoulli.stan"
    math = prefix/"stan/lib/stan_math"
    libraries = File.read(math/"make/libraries")
    cvodes = libraries.match(%r{(lib\/cvodes_([0-9\.]+))\n})[1]
    ENV["CPPFLAGS"] = %W[-I#{prefix}/stan/src
                         -I#{math} -I#{math}/#{cvodes}/include
                         -I#{Formula["eigen"].opt_include/"eigen3"}].join(" ")
    system "make", "bernoulli_model.o"
  end
end
