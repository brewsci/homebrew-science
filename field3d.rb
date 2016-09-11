class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"
  revision 4

  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "8be7ea3337e7287fa1d65a6097f762bc2849a4b11a2378e8e7138a4df308321a" => :el_capitan
    sha256 "3624d9842d9e7f933fe1170bd13ed20dc8b96a0615c938fff72c6f80b5dff657" => :yosemite
    sha256 "a070c4afd8fc757239d0a4513bef41ff3fe83cac1f36e55298b00cc858b8697b" => :mavericks
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
