class Z3 < Formula
  desc "A high-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.0.tar.gz"
  sha256 "65b72f9eb0af50949e504b47080fb3fc95f11c435633041d9a534473f3142cba"
  head "https://github.com/Z3Prover/z3.git"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "491c51fa7e7ae45022c8a8ad4f5c12010faa9d53a1ed543f1e57be32ca067893" => :yosemite
    sha256 "9053fe4bc9bccf65659a68ff6f1e41037c8eb27a68edb3404bbe44ef64775172" => :mavericks
    sha256 "74b091b81f87aec59b4610d480ffa5d7570640058ce2d7e7e09d913152221b3c" => :mountain_lion
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
