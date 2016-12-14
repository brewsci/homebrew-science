class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"
  revision 5
  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "c5a0a5275a839dd55c0a0af6d2bb687c9e179f4387285bb9b071ffb26368422a" => :sierra
    sha256 "1e623e2c9969d467d698a1426239f63ba9f4c6dbe9b0b9cae047bdd4c3cf325d" => :el_capitan
    sha256 "4fad15358324a6574194d7b4335172e0745f64164f007881a5f8ab64f70a3440" => :yosemite
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
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lField3D",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           pkgshare/"sample_code/create_and_write/main.cpp",
           "-o", "test"
    system "./test"
  end
end
