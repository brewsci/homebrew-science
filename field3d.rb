class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 2
  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "16ecdc09a0cce2f65f84f8811c89ae6d7c2435ffcb2dfc32eb27643de8a1928e" => :sierra
    sha256 "34345c087122237ef4cbccf0a491731c06d310ef3050c5039e1ae16b0bfbd789" => :el_capitan
    sha256 "ec737d80aef0a54dd21290d1b4759f67b96947e2f309d8006cbf32b4a6ee1d7d" => :yosemite
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
