class Asl < Formula
  desc "The AMPL modeling language solver library"
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/2.1.0.tar.gz"
  sha256 "57d17db3e70e4a643c1b2141766a000b36057c2eeebd51964f30e2f8a56ee4d6"
  revision 1

  bottle do
    cellar :any
    sha256 "4e643066006b30247875f22cc7e641f8620106d410e6bdfa3af723a5b6fae14e" => :el_capitan
    sha256 "f153b0c487c7936f551bbc41578813b0bc58aef6d25d232da27125429339b77b" => :yosemite
    sha256 "86268b10c60ee52ce092f0349f6f3b59806254581c8e8142c46c42ad2ed36de8" => :mavericks
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
    system "make", "install"
    mkdir libexec
    mv bin, libexec/"bin"

    if build.with? "matlab"
      mkdir_p (pkgshare/"matlab")
      mv Dir["#{libexec}/bin/*.mexmaci64"], (pkgshare/"matlab")
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
