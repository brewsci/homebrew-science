class Visp < Formula
  desc "Visual Servoing Platform library, version 3"
  homepage "https://visp.inria.fr"

  stable do
    url "http://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.0.0.tar.gz"
    sha256 "f9fa6f16f5c06d4eaa91ed374ecd7416ad49639d9f3a1865b21933af368e720f"
  end

  bottle do
    cellar :any
    sha256 "092bb8d4bb1b74ee69ca402ffe66d73677cf5e1b61fb9d6931299b2cd0827880" => :yosemite
    sha256 "b961e8a9d5b95312159989fccfea007cd931095cc977d0c855cc8177dcfbfb7e" => :mavericks
    sha256 "c3aa7137649ad12c5960fbde9b863d09b8dcc2e1fa28ec339f6a24b9134d0db6" => :mountain_lion
  end

  option :cxx11

  depends_on "cmake"     => :build
  depends_on "opencv3"   => :recommended
  depends_on "libdc1394" => :recommended
  depends_on "libxml2"   => :recommended
  depends_on "gsl"       => :recommended
  depends_on "zbar"      => :recommended
  depends_on :x11        => :recommended
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
