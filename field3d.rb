class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"
  revision 4

  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "d0107711db03b54f6b62013ab4e666eefcaca58f7a1ae6cc7d186c1a8b4ef0d1" => :sierra
    sha256 "2272ece43f49879bab6aae6dca9d71677a2b5ef1dd27a586935913cc816d655c" => :el_capitan
    sha256 "df9877f8b6880c372632118bcd4a887f6fc421dc6573f0ee982637bfdb64066d" => :yosemite
    sha256 "13bf432aadd33a514dd5abdcee4e5934e2531568f554362a0ef29713d4de599e" => :mavericks
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
