class Blis < Formula
  homepage "https://code.google.com/p/blis/"
  url "https://github.com/flame/blis/archive/0.1.6.tar.gz"
  sha256 "04171ffd39ece22976f97b6080efc27d69f8fd27a0cfd077fe85f8393cc489ff"
  head "https://github.com/flame/blis.git"

  option "with-configuration=",
      "BLIS framework configuration name (default: reference)\n" \
      "\tSee https://code.google.com/p/blis/wiki/BuildSystem" \
      "#Step_1:_Choose_a_framework_configuration"
  option "without-check", "Skip build-time tests (not recommended)"
  option "without-shared", "Do not build as a shared library"
  option "without-static", "Do not build as a static library"

  def install
    if build.without?("dynamic") && build.without?("static")
      raise "Must build either a static or dynamic library"
    end

    system "./configure",
        "-p#{prefix}",
        ARGV.value("with-configuration") || "reference"
    if build.with? "check"
      system "make", "test"
      prefix.install "output.testsuite"
    end
    system "make", "install",
        "BLIS_ENABLE_DYNAMIC_BUILD=" + (build.with?("dynamic") ? "yes" : "no"),
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
