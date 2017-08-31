class Xcdf < Formula
  desc "High performance bitpacking algorithm."
  homepage "https://github.com/jimbraun/XCDF"
  url "https://github.com/jimbraun/XCDF/archive/v3.00.02.tar.gz"
  sha256 "a69b2996c630400a7952695def833a4e2dfef970eedba6be50d119623a5733cd"
  head "https://github.com/jimbraun/XCDF.git"

  bottle do
    cellar :any
    sha256 "b8f96d4b44fea3a30751f88f43779fdea50ee6588da74f4e1b639cae70b88703" => :sierra
    sha256 "e3c6f06ee0df724563e956fd7db74b851ca4668f8113f04fa085110a47fac1a4" => :el_capitan
    sha256 "5a423e15d21339f3db529cb6ccadae717c10bd9a1e9ad7e413a77b0fbe6acd4c" => :yosemite
    sha256 "f634b5934dcc50144f273938e708ae9e5b609b7e68ac673448ce452ecff559f8" => :x86_64_linux
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
