class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.6.tar.gz"
  sha256 "3c07fd21308c96477a2c900032e21d937739c233ee273b4347a0d4a84a32d09f"
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    sha256 "4f5232111d1ff92aa9798b46adf94ffe7add2f9c24739b84b3bc1a1f7e0ca220" => :sierra
    sha256 "1aecfdfb060db51bf4c053095b53c6d2fd28f9d473a3fd705741dfd72f22799d" => :el_capitan
    sha256 "5bc9046f3c4987025e273aac525342bda48fae68c651038dceebae88c4e4296b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openblas" unless OS.mac?

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples"

    lib64 = Pathname.new "#{lib}64"
    mv lib64, lib if lib64.directory?
  end

  test do
    cp pkgshare/"examples/thybrdc.c", testpath
    system ENV.cc, "-o", testpath/"thybrdc", "-I#{include}/cminpack-1", "thybrdc.c", "-L#{lib}", "-lcminpack", "-lm"
    system testpath/"thybrdc"
  end
end
