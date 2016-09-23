class Visp < Formula
  desc "Visual Servoing Platform library, version 3"
  homepage "https://visp.inria.fr"
  url "http://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.0.0.tar.gz"
  sha256 "f9fa6f16f5c06d4eaa91ed374ecd7416ad49639d9f3a1865b21933af368e720f"
  revision 1

  bottle do
    sha256 "d3ade2f6f9454dad6f6c857fe82ca9c2919537fa5a9487471821542b135cba6c" => :el_capitan
    sha256 "42d7a0f886cd8089b2a9601b47e158f8a4ace338ec7c3a46353e5fac7dbaa3e8" => :yosemite
    sha256 "b9a5e13f4c657d994dc05226893869ff7d3a4a15f36c189c631518bab4ed87a4" => :mavericks
  end

  option :cxx11

  depends_on "cmake"     => :build
  depends_on "opencv3"   => :recommended
  depends_on "libdc1394" => :recommended
  depends_on "libxml2"   => :recommended
  depends_on "gsl"       => :recommended
  depends_on "zbar"      => :recommended
  depends_on x11: :recommended
  option :cxx11

  def arg_switch(opt)
    (build.with? opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_DEMOS=OFF
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TUTORIALS=OFF
    ]

    args << "-DUSE_CPP11=ON" if build.cxx11?

    args << "-DUSE_X11="          + arg_switch("x11")
    args << "-DUSE_OPENCV="       + arg_switch("opencv3")
    args << "-DUSE_DC1394="       + arg_switch("libdc1394")
    args << "-DUSE_XML2="         + arg_switch("libxml2")
    args << "-DUSE_GSL="          + arg_switch("gsl")
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
