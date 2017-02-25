class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.6.tar.gz"
  sha256 "3c07fd21308c96477a2c900032e21d937739c233ee273b4347a0d4a84a32d09f"
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    sha256 "7106b511d0a7c2331f5d48fce34405f1e3bb290a06920f554fef1f290f849b78" => :yosemite
    sha256 "a97298ee71603be4b8f67122b0652b43bf694fbc7c0f0780e2433e0f3ce22217" => :mavericks
    sha256 "89476a80b512c3b64d0a2785ce1508c7f3b58370530ffe4c711f57029b790af2" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/thybrdc.c", testpath
    system ENV.cc, "-o", testpath/"thybrdc", "-I#{include}/cminpack-1", "thybrdc.c", "-L#{lib}", "-lcminpack"
    system testpath/"thybrdc"
  end
end
