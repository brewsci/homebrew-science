class Asl < Formula
  desc "The AMPL modeling language solver library"
  homepage "http://www.ampl.com"
  url "https://github.com/ampl/mp/archive/2.0.2.tar.gz"
  sha256 "34d0ffef4af6f34ac5e50cfdb6819af823c2f6fb1db763b82de98b08d9069f63"

  bottle do
    sha256 "73a5a3c57d8f8dad40868703443f4ba56b3509d98afd35783d5f34dafd7095d6" => :yosemite
    sha256 "8f81c5d487f55cd031515d6d239fc781a2a50bc22a8f1a6e4b9dce07370803d6" => :mavericks
    sha256 "1362349ddc7bf0ce8087979821b148811a1f351ef32bc80d54249d2c97df9c51" => :mountain_lion
  end

  option "with-matlab", "Build MEX files for use with Matlab"
  option "with-mex-path=", "Path to MEX executable, e.g., /path/to/MATLAB.app/bin/mex (default: mex)"

  depends_on "cmake" => :build
  depends_on "doxygen" => :optional

  # https://github.com/ampl/mp/issues/55
  patch :p1 do
    url "https://github.com/ampl/mp/commit/8a777497b9ccac035a5d59cb12e3d9a3ba815256.diff"
    sha256 "5da9fa46e1509bce744933166891da12c895b8ffd2e6705008377bdb81259b22"
  end

  # https://github.com/ampl/mp/pull/60
  patch :p1 do
    url "https://gist.githubusercontent.com/dpo/dde4bf8030209fcf0569/raw/ed93e2653b51b5da754aabc89e08704421860009/a.diff"
    sha256 "7a6eb262d48e9c9e869ae72e8dbc64adf2ed819f5b3f6e298cd5fae3784d0e8d"
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
