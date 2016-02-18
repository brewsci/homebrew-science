class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.1.8.tar.gz"
  sha256 "b649a13ccdf0040e44bdbd5cf39e7c9a24cc0ac41ded1ad10681fe9bcce4cc89"
  head "https://github.com/flame/blis.git"

  deprecated_option "without-check" => "without-test"

  option "with-configuration=",
      "BLIS framework configuration name (default: reference)\n" \
      "\thttps://github.com/flame/blis/wiki/BuildSystem" \
      "#step-1-choose-a-framework-configuration"
  option "without-test", "Skip build-time tests (not recommended)"
  option "without-shared", "Do not build as a shared library"
  option "without-static", "Do not build as a static library"

  def install
    if build.without?("shared") && build.without?("static")
      raise "Must build either a static or a shared library"
    end

    system "./configure",
        "-p#{prefix}",
        ARGV.value("with-configuration") || "reference"
    if build.with? "check"
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
