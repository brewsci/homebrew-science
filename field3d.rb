class Field3d < Formula
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"
  revision 2

  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "6bceec6214a549add84d22e8157a77f1837d2d92a091d58f5f3581d65f4f667f" => :yosemite
    sha256 "a2a5910fdfa5fbdec7bed7f36669e34811054135d89d542aa886d4795bf9ee92" => :mavericks
    sha256 "a144bb3a86c0801bd601572286c8cb5595316112112d07d8a0d5cb20fe49af3b" => :mountain_lion
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "ilmbase"
  depends_on "hdf5"

  def install
    scons

    include.install Dir["install/**/**/release/include/*"]
    lib.install Dir["install/**/**/release/lib/*"]
    man1.install "man/f3dinfo.1"
    pkgshare.install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lfield3d",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           pkgshare/"sample_code/create_and_write/main.cpp",
           "-o", "test"
    system "./test"
  end
end
