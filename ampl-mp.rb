class AmplMp < Formula
  desc "The AMPL modeling language solver library"
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/3.1.0.tar.gz"
  sha256 "587c1a88f4c8f57bef95b58a8586956145417c8039f59b1758365ccc5a309ae9"

  bottle do
    cellar :any
    sha256 "d017b21e844f283ff93005b373303ea0dba8687f5df88d59a1ff94db1e3103a6" => :sierra
    sha256 "251f1ea420b39ba36b960684ad201d0bb0f1764e3b3b8459efe06f6e2c8c2bba" => :el_capitan
    sha256 "eae46d7447404c3a38d041a619b423c195a5533e39d32fa06c6a377b544b534f" => :yosemite
  end

  option "with-matlab", "Build MEX files for use with Matlab"
  option "with-mex-path=", "Path to MEX executable, e.g., /path/to/MATLAB.app/bin/mex (default: mex)"
  option "without-test", "Skip build-time tests (not recommended)"

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/v1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
  end

  def install
    cmake_args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}", "-DCMAKE_BUILD_TYPE=None",
                  "-DCMAKE_FIND_FRAMEWORK=LAST", "-DCMAKE_VERBOSE_MAKEFILE=ON", "-Wno-dev",
                  "-DBUILD_SHARED_LIBS=True"]
    cmake_args << ("-DMATLAB_MEX=" + (ARGV.value("with-mex-path") || "mex")) if build.with? "matlab"

    system "cmake", ".", *cmake_args
    system "make", "all"
    system "make", "test" if build.with? "test"
    system "install_name_tool", "-change", "@rpath/libmp.3.dylib", lib/"libmp.dylib", "bin/libasl.dylib" if OS.mac?
    system "make", "install"
    mkdir libexec
    mv bin, libexec/"bin"

    if build.with? "matlab"
      mkdir_p (pkgshare/"matlab")
      mv Dir["#{libexec}/bin/*.mex*"], pkgshare/"matlab"
    end

    resource("miniampl").stage do
      system "make", "SHELL=/bin/bash", "CXX=#{ENV["CC"]} -std=c99", "LIBAMPL_DIR=#{prefix}", "LIBS=-L$(LIBAMPL_DIR)/lib -lasl -lm -ldl"
      bin.install "bin/miniampl"
      (pkgshare/"example").install "Makefile", "README.rst", "src", "examples"
    end
  end

  def caveats
    s = ""
    if build.with? "matlab"
      s += <<-EOS.undent
        Matlab interfaces have been installed to

          #{opt_pkgshare}/matlab
      EOS
    end
    s
  end

  test do
    cp Dir["#{opt_pkgshare}/example/examples/*"], testpath
    cd testpath do
      system "#{opt_bin}/miniampl", "wb", "showname=1", "showgrad=1"
    end
  end
end
