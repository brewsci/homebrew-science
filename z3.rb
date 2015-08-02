class Z3 < Formula
  desc "A high-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.0.tar.gz"
  sha256 "65b72f9eb0af50949e504b47080fb3fc95f11c435633041d9a534473f3142cba"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    cellar :any
    sha256 "f288000445d47ae31fd3ed128cc560d0b3792bfc528a9f76168d8a1bb766e501" => :yosemite
    sha256 "494af7b3806ad8d222d7d4f0a15a0fd649f648e40a30e29353afa80948a0df44" => :mavericks
    sha256 "a9b987921c8e84bb8759e9a408861d791fc0a1ec3698563bb80fd8fead6b03b6" => :mountain_lion
  end

  depends_on :python

  def install
    package_dir = lib/"python2.7/site-packages"
    mkdir_p package_dir
    inreplace "scripts/mk_util.py", /^PYTHON_PACKAGE_DIR=.*/, "PYTHON_PACKAGE_DIR=\"#{package_dir}\""

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
