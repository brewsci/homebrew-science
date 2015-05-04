class Field3d < Formula
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"

  head "https://github.com/imageworks/Field3D.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "705f96253caac068e68444180a5f7a0e561dcbea6ea2e769dfc327d2bb7c0cf7" => :yosemite
    sha256 "058a60e3ee7e584c163f5863807dbce5371d2c951b47c83f50014c34a859b812" => :mavericks
    sha256 "7c38e793d5bd9201207a38d263d715096fcfa8cf73c0a140b542f6c5999606a9" => :mountain_lion
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
    (share/"field3d").install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lfield3d",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           share/"field3d/sample_code/create_and_write/main.cpp",
           "-o", "test"
    system "./test"
  end
end
