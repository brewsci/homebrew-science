class Xcdf < Formula
  desc "High performance bitpacking algorithm."
  homepage "https://github.com/jimbraun/XCDF"
  url "https://github.com/jimbraun/XCDF/archive/v3.00.00.tar.gz"
  sha256 "10e4173471f59e137e598b70bcc5bc02267f093e2cd15089783545869b65c538"
  head "https://github.com/jimbraun/XCDF.git"

  bottle do
    cellar :any
    sha256 "ad83615a6d90b1c6d8e9bf53ec615fad0e5803f055bf234e103356f6adc2f50a" => :el_capitan
    sha256 "84d224c1bc39bb28549ad8e4c08f0d457fbd3fce472132be95fe71e9fabc05ad" => :yosemite
    sha256 "223d55367d2891499e9f5b0deeb0b63f6ef9ec61d0a953912b8fc4388c205104" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :python

  def install
    dylib = OS.mac? ? "dylib" : "so"
    mktemp do
      args = *std_cmake_args
      python_executable = `which python`.strip
      python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
      python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
      python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp
      args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
      # CMake picks up the system's python dylib, even if we have a brewed one.
      if File.exist? "#{python_prefix}/Python"
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
        args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
      elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
        args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.#{dylib}'"
      elsif File.exist? "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.#{dylib}"
        args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.so'"
      else
        odie "No libpythonX.Y.{dylib|so|a} file found!"
      end

      system "cmake", buildpath, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xcdf-append-test"
    system "#{bin}/xcdf-buffer-fill-test"
    system "#{bin}/xcdf-concat-seek-test"
    system "#{bin}/xcdf-random-test"
    system "#{bin}/xcdf-seek-test"
    system "#{bin}/xcdf-simple-test"
    system "#{bin}/xcdf-speed-test"
  end
end
