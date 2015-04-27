class Visp < Formula
  homepage "http://www.irisa.fr/lagadic/visp/visp.html"
  head "svn://scm.gforge.inria.fr/svn/visp/trunk/ViSP ViSP-code"

  stable do
    url "http://gforge.inria.fr/frs/download.php/latestfile/475/ViSP-2.10.0.tar.gz"
    sha256 "1c8a37cadd0012526be9ceaa182eb21fb0d45aac622a1f0f2d255225e85797aa"
  end

  depends_on "cmake"    => :build
  depends_on "opencv"   => :recommended
  depends_on "jpeg"     => :recommended
  depends_on "libpng"   => :recommended
  depends_on "zbar"     => :recommended
  depends_on "ffmpeg"   => :optional

  option :cxx11

  option "with-demos", "Build with demos"
  option "with-examples", "Build with examples"
  option "without-tests", "Build without tests"
  option "with-tutorials", "Build with tutorials"

  def arg_switch(opt)
    (build.with? opt) ? "ON" : "OFF"
  end

  def install
    ENV.cxx11 if build.cxx11?

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DUSE_X11=OFF
    ]

    args << "-DUSE_FFMPEG="       + arg_switch("ffmpeg")
    args << "-DUSE_LIBJPEG="      + arg_switch("jpeg")
    args << "-DUSE_LIBPNG="       + arg_switch("libpng")
    args << "-DUSE_OPENCV="       + arg_switch("opencv")
    args << "-DUSE_ZBAR="         + arg_switch("zbar")

    args << "-DBUILD_DEMOS="      + arg_switch("demos")
    args << "-DBUILD_EXAMPLES="   + arg_switch("examples")

    mkdir "macbuild" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <visp/vpConfig.h>
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
