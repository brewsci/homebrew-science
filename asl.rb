class Asl < Formula
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/2.0.1.tar.gz"
  sha256 "628b5ef035b58184113e721b05b9340c8bce77d22f9261eaa2448ec96d97dd8a"

  bottle do
    sha256 "f2c4e1a1864add2c2480e9b673e9c5f269054e3ab704cbfe04873b0b34a5b386" => :yosemite
    sha256 "cafce1cf283108446c6106cec2918ec642cb8d5f1dc5d797294b9bca69233a97" => :mavericks
    sha256 "0c7734c9e10a0610f29b0ab556fefe8d6e171c37430c097efe621e9c21a74e24" => :mountain_lion
  end

  option "with-matlab", "Build MEX files for use with Matlab"
  option "with-mex-path=", "Path to MEX executable, e.g., /path/to/MATLAB.app/bin/mex (default: mex)"

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional

  # https://github.com/ampl/mp/issues/55
  patch do
    url "https://github.com/ampl/mp/commit/8a777497b9ccac035a5d59cb12e3d9a3ba815256.diff"
    sha256 "5da9fa46e1509bce744933166891da12c895b8ffd2e6705008377bdb81259b22"
  end

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/v1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
  end

  def install
    cmake_args = ["-DCMAKE_INSTALL_PREFIX=#{libexec}", "-DCMAKE_BUILD_TYPE=None",
                  "-DCMAKE_FIND_FRAMEWORK=LAST", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-Wno-dev",
                  "-DBUILD_SHARED_LIBS=True"]
    cmake_args << ("-DMATLAB_MEX=" + (ARGV.value("with-mex-path") || "mex")) if build.with? "matlab"

    system "cmake", ".", *cmake_args
    system "make", "all"
    system "make", "test"
    system "make", "install"

    lib.mkdir
    ln_sf Dir["#{libexec}/lib/*.a"], lib
    ln_sf Dir["#{libexec}/lib/*.dylib"], lib

    include.mkdir
    ln_sf Dir["#{libexec}/include/*"], include

    if build.with? "matlab"
      mkdir_p (share / "asl/matlab")
      ln_sf Dir["#{libexec}/bin/*.mexmaci64"], (share / "asl/matlab")
    end

    resource("miniampl").stage do
      system "make", "SHELL=/bin/bash", "CXX=#{ENV["CC"]} -std=c99", "LIBAMPL_DIR=#{prefix}", "LIBS=-L$(LIBAMPL_DIR)/lib -lasl -lm -ldl"
      bin.install "bin/miniampl"
      (share / "asl/example").install "Makefile", "README.rst", "src", "examples"
    end
  end

  def caveats
    s = ""
    if build.with? "matlab"
      s += <<-EOS.undent
        Matlab interfaces have been installed to

          #{opt_share}/asl/matlab
      EOS
    end
    s
  end

  test do
    system "#{bin}/miniampl", "#{share}/asl/example/examples/wb", "showname=1", "showgrad=1"
  end
end
