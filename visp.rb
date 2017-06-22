class Visp < Formula
  desc "Visual Servoing Platform library"
  homepage "https://visp.inria.fr"
  url "https://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.0.1.tar.gz"
  sha256 "8aefd21f30dd4f6d210c59c28704f9e3adf874e3337571a3ae65a65946c94326"
  revision 1

  bottle do
    sha256 "255941dfb9c5c36ad20c96f2cf7c7f7614171de6499319ecae31a309a74ef2e8" => :sierra
    sha256 "0262f88ac08ef7afe9d69b31f4d88c27226865163a171297e27f91928f4a6258" => :el_capitan
    sha256 "9e172a63d23f0cffede0e023fd96b20bc4c960a7851015b3998503a5dd13b45e" => :yosemite
  end

  option :cxx11

  depends_on "cmake"     => :build
  depends_on "gsl"       => :recommended
  depends_on "jpeg"      => :recommended
  depends_on "libdc1394" => :recommended
  depends_on "libpng"    => :recommended
  depends_on "libxml2"   => :recommended
  depends_on "opencv3"   => :recommended
  depends_on "zbar"      => :recommended
  depends_on :x11        => :recommended

  def arg_switch(opt)
    build.with?(opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %w[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_DEMOS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TUTORIALS=OFF
    ]

    args << "-DUSE_CPP11=ON" if build.cxx11?

    args << "-DUSE_DC1394="       + arg_switch("libdc1394")
    args << "-DUSE_GSL="          + arg_switch("gsl")
    args << "-DUSE_JPEG="         + arg_switch("jpeg")
    args << "-DUSE_OPENCV="       + arg_switch("opencv3")
    args << "-DUSE_PNG="          + arg_switch("libpng")
    args << "-DUSE_X11="          + arg_switch("x11")
    args << "-DUSE_XML2="         + arg_switch("libxml2")
    args << "-DUSE_ZBAR="         + arg_switch("zbar")

    mkdir "macbuild" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <visp3/core/vpConfig.h>
      #include <iostream>
      int main()
      {
        std::cout << VISP_VERSION_MAJOR << "." << VISP_VERSION_MINOR <<
                "." << VISP_VERSION_PATCH << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s
  end
end
