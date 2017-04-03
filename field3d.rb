class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  head "https://github.com/imageworks/Field3D.git"

  bottle do
    cellar :any
    sha256 "32677f52e969b9535c977e5b1578c1816242546067448ad3015febd5edcfdc16" => :sierra
    sha256 "cd099d0f6c6cf138fdca86ae8c3b013034282a744d73f518bee7603880998ccd" => :el_capitan
    sha256 "9d38fee813b42a2e944eaaffcc177e14961581af7eaa16f85bb35ebd874217d9" => :yosemite
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
