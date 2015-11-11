class Xcdf < Formula
  desc "High performance bitpacking algorithm."
  homepage "https://github.com/jimbraun/XCDF"
  url "https://github.com/jimbraun/XCDF/archive/v2.09.00.tar.gz"
  sha256 "49a2357392008cf12dc956a2d43e4b0948f1d8c42e014fa04db7e8ac4d267567"
  head "https://github.com/jimbraun/XCDF.git"

  depends_on "cmake" => :build
  depends_on :python

  def install
    mktemp do
      pypref = `python -c 'import sys;print(sys.prefix)'`.strip
      pyinc = `python -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.strip
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DPYTHON_INCLUDE_DIR='#{pyinc}'
        -DPYTHON_LIBRARY='#{pypref}/lib/libpython2.7.dylib'
      ]

      system "cmake", buildpath, *(std_cmake_args + args)
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
