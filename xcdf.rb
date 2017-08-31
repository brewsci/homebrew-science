class Xcdf < Formula
  desc "High performance bitpacking algorithm."
  homepage "https://github.com/jimbraun/XCDF"
  url "https://github.com/jimbraun/XCDF/archive/v3.00.02.tar.gz"
  sha256 "a69b2996c630400a7952695def833a4e2dfef970eedba6be50d119623a5733cd"
  head "https://github.com/jimbraun/XCDF.git"

  bottle do
    cellar :any
    sha256 "33c2a71a6883c7c0be0059e0abce648ccb8419234d2c5794abe7d885a9b75d69" => :sierra
    sha256 "ae3983be7f420ca2814f0db1390c6ce22bbcf47b6f456f8dde294fe86019abbf" => :el_capitan
    sha256 "1dee657b4db2a0e0dfaeba574588d5cebace9fa26726bb54c6a65c09e0e89cc6" => :yosemite
    sha256 "cad74a0152cd77faa0b37d24c66978f0a82d7654ed23814d1c86a18413954007" => :x86_64_linux
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
