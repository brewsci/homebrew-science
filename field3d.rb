class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 2
  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "879babcad82018f9e038160084d19d8f669daeb30c7ba8f3d610290046ebc8ad" => :sierra
    sha256 "eaaff788c71a868d2a1ebbeb6f8e36c30b266aae7993e9e5af9a47e2ea43b015" => :el_capitan
    sha256 "49507a1cf4925fe42f09cdb29a993bc5b90e247cd0cb4652e8675acbdfcf134d" => :yosemite
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
