class Field3d < Formula
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.6.1.tar.gz"
  sha256 "05dcf96db1779c2db8fc9de518bbc8482f43e8cd8cb995ebb06fb22d83879a5a"

  head "https://github.com/imageworks/Field3D.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "a8b12023df85cce80486922f6f1dc799193a73c0" => :yosemite
    sha1 "cda2b036a3a36d3000406943f1f708d0cf71fd0a" => :mavericks
    sha1 "9e7854c38d8af4a2f07f21b931d2751a533813e9" => :mountain_lion
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
