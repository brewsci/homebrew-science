class Z3 < Formula
  homepage "http://z3.codeplex.com/"
  url "https://github.com/Z3Prover/z3/archive/z3-4.3.2.tar.gz"
  sha256 "c9ccc7d1e9b9dcc7129eaf1160c1a577726f4e870ba4681ea9c8a4521bfaa0f3"
  head "https://github.com/Z3Prover/z3.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "2ce2e28b1ed47fd2df764fdba8ed61fa6896f6cb4f443afed7dcee6fae69b080" => :yosemite
    sha256 "cb5f83f5a2b2d263d51ae8df5c0cbf7fdee4d72d58c26a17ea57f19bf2a96ccb" => :mavericks
    sha256 "9e58713737a98619cc05c0f89fb63ba61ed66c4a98beeea650d6a83c4bdb8beb" => :mountain_lion
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
    share.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           share/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
