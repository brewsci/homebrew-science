class Z3 < Formula
  homepage "http://z3.codeplex.com/"
  url "https://github.com/Z3Prover/z3/archive/z3-4.3.2.tar.gz"
  sha256 "c9ccc7d1e9b9dcc7129eaf1160c1a577726f4e870ba4681ea9c8a4521bfaa0f3"
  head "https://github.com/Z3Prover/z3.git"

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
    share.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           share/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
