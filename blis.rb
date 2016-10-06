class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.2.1.tar.gz"
  sha256 "45087029417934011bf4ebefff24f1ff228299e324238170c08bc858ffae0dbf"
  head "https://github.com/flame/blis.git"

  bottle do
    cellar :any
    sha256 "9a172421f66db44f87d010c06a1bb9b892cd537e4dee53a6626a43fbc30edc8c" => :el_capitan
    sha256 "48e1a717c837523b9bb8ce7cbf0a570adeffe5d1e97364ebc1dfcd2fb4313221" => :yosemite
    sha256 "97d8f1705db1212ac45c3feb6c9aba7e43af45299930f7955562d02ee1f6186c" => :mavericks
  end

  deprecated_option "without-check" => "without-test"

  fails_with :clang do
    cause "make_defs.mk:51: *** gcc is required for this configuration"
  end

  option "with-configuration=",
      "BLIS framework configuration name (default: reference)\n" \
      "\thttps://github.com/flame/blis/wiki/BuildSystem" \
      "#step-1-choose-a-framework-configuration"
  option "without-test", "Skip build-time tests (not recommended)"
  option "without-shared", "Do not build as a shared library"
  option "without-static", "Do not build as a static library"

  depends_on "gcc"

  def install
    if build.without?("shared") && build.without?("static")
      raise "Must build either a static or a shared library"
    end

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
      <<-EOS.undent
        BLIS was built with the reference configuration.  Performance is
        highly-dependent on the selected configuration and may not be optimal
        for this system.  Please consider specifying the --with-configuration
        option when installing BLIS if performance is important.
        EOS
    end
  end
end
