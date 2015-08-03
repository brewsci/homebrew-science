class Z3 < Formula
  desc "A high-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.0.tar.gz"
  sha256 "65b72f9eb0af50949e504b47080fb3fc95f11c435633041d9a534473f3142cba"
  head "https://github.com/Z3Prover/z3.git"
  revision 1

  bottle do
    cellar :any
    sha256 "f498595a49c4bed2ee6c171fb8c07cf7a5e12e75257f48686e629534df4d2cab" => :yosemite
    sha256 "c5aced93f2345775852e88f6f0a44b6c1accf7321dfeb60e89233922e4c243ab" => :mavericks
    sha256 "95d2d303a952548d78b97fe9ab020a4ad29a5e1788275e8a0e92534fc4049de3" => :mountain_lion
  end

  def install
    inreplace "scripts/mk_util.py", "dist-packages", "site-packages"
    system "python", "scripts/mk_make.py", "--prefix=#{prefix}"

    cd "build" do
      system "make"
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
