class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"
  revision 6
  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "ba463a26263411b28faecef5d47098ac214f206719ba0ad279057a6527e9f58e" => :sierra
    sha256 "b539768c37c41497a6b391800f6f47afab85ab6826de8c3e05235601a4919a73" => :el_capitan
    sha256 "8ba24df776f73a8f6d2407a242145c7b6f70a352dd4dd2a8d95b04c72fffa55d" => :yosemite
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
