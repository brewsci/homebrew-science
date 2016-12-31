class Visp < Formula
  desc "Visual Servoing Platform library, version 3"
  homepage "https://visp.inria.fr"
  url "http://gforge.inria.fr/frs/download.php/latestfile/475/visp-3.0.0.tar.gz"
  sha256 "f9fa6f16f5c06d4eaa91ed374ecd7416ad49639d9f3a1865b21933af368e720f"
  revision 2

  bottle do
    sha256 "6101dda8cfd44e9a05e47e8c5dc0865f98bfd37ed6a657be761d779c44c6209b" => :sierra
    sha256 "f36f468573380e74ff67c798875850740294413dacc34955fe58f7251dfcf877" => :el_capitan
    sha256 "8a0bafceec284d737747b66d1ccf5efe25c32fe1a644aba4c24786b26ef122a3" => :yosemite
  end

  option :cxx11

  depends_on "cmake"     => :build
  depends_on "opencv3"   => :recommended
  depends_on "libdc1394" => :recommended
  depends_on "libxml2"   => :recommended
  depends_on "gsl"       => :recommended
  depends_on "zbar"      => :recommended
  depends_on :x11        => :recommended

  def arg_switch(opt)
    (build.with? opt) ? "ON" : "OFF"
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
