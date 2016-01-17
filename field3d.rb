class Field3d < Formula
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"
  revision 2

  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "b3b659d655a043988258219f64ae83a521a4c65e6a8d851b1f942d9b8827e8e4" => :el_capitan
    sha256 "3d60c590970faf76a95ac3331e6e2119f48ad0ec678f98f3cfff61b4a13ae0bf" => :yosemite
    sha256 "e724ee6d0a3dfd66222b69ef9f1ce75636e01a23748a5a97f5883ea5c162aa7d" => :mavericks
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
