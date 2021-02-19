class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.2.1.tar.gz"
  sha256 "45087029417934011bf4ebefff24f1ff228299e324238170c08bc858ffae0dbf"
  head "https://github.com/flame/blis.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any, sierra:     "cf0e1e538924bf819fc37282dcdefd7d73baefd17d6ceee796f2592e656479ea"
    sha256 cellar: :any, el_capitan: "964fbe2656d2f991879c5361b8ffa4132f70fe733ec0f596d3ac6152ae82dd19"
    sha256 cellar: :any, yosemite:   "46112ec1a9dda5cfa5f66974d54d0ccdf809e5fcc3507b0caf1bf5ca2dd6436c"
  end

  option "with-configuration=",
      "BLIS framework configuration name (default: reference)\n" \
      "\thttps://github.com/flame/blis/wiki/BuildSystem" \
      "#step-1-choose-a-framework-configuration"

  option "without-test", "Skip build-time tests (not recommended)"
  option "without-shared", "Do not build as a shared library"
  option "without-static", "Do not build as a static library"

  deprecated_option "without-check" => "without-test"

  depends_on "gcc"

  fails_with :clang do
    cause "make_defs.mk:51: *** gcc is required for this configuration"
  end

  def install
    raise "Must build either a static or a shared library" if build.without?("shared") && build.without?("static")

    system "./configure",
        "-p#{prefix}",
        ARGV.value("with-configuration") || "reference"
    if build.with? "test"
      system "make", "test"
      prefix.install "output.testsuite"
    end
    system "make", "install",
        "BLIS_ENABLE_DYNAMIC_BUILD=" + (build.with?("shared") ? "yes" : "no"),
        "BLIS_ENABLE_STATIC_BUILD=" + (build.with?("static") ? "yes" : "no")
  end

  def caveats
    unless ARGV.value("with-configuration")
      <<~EOS
        BLIS was built with the reference configuration.  Performance is
        highly-dependent on the selected configuration and may not be optimal
        for this system.  Please consider specifying the --with-configuration
        option when installing BLIS if performance is important.
      EOS
    end
  end
end
