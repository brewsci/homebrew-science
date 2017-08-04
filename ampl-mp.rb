class AmplMp < Formula
  desc "The AMPL modeling language solver library"
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/3.1.0.tar.gz"
  sha256 "587c1a88f4c8f57bef95b58a8586956145417c8039f59b1758365ccc5a309ae9"
  revision 2

  head "https://github.com/ampl/mp.git"

  bottle do
    cellar :any
    sha256 "d638f4f5c4c0195692cb81d23ec37d48376b7070e5dc39b043f21ef06e2301da" => :sierra
    sha256 "1366f91c8f7b8199f960f33ff9dea1a0aa3dd3e4f3d91e770ed27699c131c507" => :el_capitan
    sha256 "6be0d164fd2758589aaf3c962ff9e2bb2ddc597734c99bc7588bb566e2362abd" => :yosemite
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

    # install missing header files
    # see https://github.com/ampl/mp/issues/110
    %w[errchk.h jac2dim.h obj_adj.h].each { |h| cp "src/asl/solvers/#{h}", include/"asl" }

    if build.with? "matlab"
      mkdir_p (pkgshare/"matlab")
      mv Dir["#{libexec}/bin/*.mex*"], pkgshare/"matlab"
    end

    resource("miniampl").stage do
      system "make", "SHELL=/bin/bash", "CXX=#{ENV["CC"]} -std=c99", "LIBAMPL_DIR=#{prefix}", "LIBS=-L$(LIBAMPL_DIR)/lib -lasl -lmp -lm -ldl"
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
