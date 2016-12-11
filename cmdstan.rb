class Cmdstan < Formula
  desc "Probabilistic programming for Bayesian inference"
  homepage "http://mc-stan.org/"
  # tag "math"
  url "https://github.com/stan-dev/cmdstan/releases/download/v2.12.0/cmdstan-2.12.0.tar.gz"
  sha256 "717fbc25fbf10db6e6315f4cdd74f38d32afaf153bbdade259bf838deb6af774"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "439e42f2d4dbc36b99cb256bc9f5758d2d37bd7d9fc6dc84bc23074fb4f94cb6" => :sierra
    sha256 "f7f4e0b2c57a89e3e45cffae097ada883929e55f7f2b15e86fa6905dc3fadf22" => :el_capitan
    sha256 "d6bff4220142b0cbcfe88cf7fd5d6375ef6613ec9510375432c574eeffe18771" => :yosemite
    sha256 "52e8fca63e84a9c28e60b9cec528dc1327562c13acf337ba48cf2df8f5e0cb58" => :x86_64_linux
  end

  depends_on "boost"
  depends_on "homebrew/versions/eigen32"

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
                         -I#{Formula["eigen32"].opt_include/"eigen3"}].join(" ")
    system "make", "bernoulli_model.o"
  end
end
