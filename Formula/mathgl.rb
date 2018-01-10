class Mathgl < Formula
  desc "Scientific graphics library"
  homepage "https://mathgl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mathgl/mathgl/mathgl%202.3.5/mathgl-2.3.5.1.tar.gz"
  sha256 "77a56936f5a763fc03480c9c1fe8ed528a949b3d63b858c91abc21c731acf0db"
  revision 4

  bottle do
    sha256 "ca5e138c7722336d414cff98c59d5c5bfcf1ff36b20c74035a032adf8ff0246d" => :sierra
    sha256 "6fbe7bc574f7996873c1db9de80648f72f4fa43cce4be52a70b1b4c72c738878" => :el_capitan
    sha256 "7a04bd671cad956798cb424745cd9fba651096f7e2561ca638710087db5ac4f3" => :yosemite
    sha256 "7187fee2d695061e44ff520fc5076254a2aeb28636d66cda0bef9073a1a8bed7" => :x86_64_linux
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "cmake"   => :build
  depends_on "gsl"     => :recommended
  depends_on "jpeg"    => :recommended
  depends_on "libharu" => :recommended
  depends_on "libpng"  => :recommended
  depends_on "hdf5"    => :optional
  depends_on "fltk"    => :optional
  depends_on "wxmac"   => :optional
  depends_on "giflib"  => :optional
  depends_on "qt"      => :optional
  depends_on :x11 if build.with? "fltk"

  if OS.linux?
    depends_on "linuxbrew/xorg/xorg"
    depends_on "freeglut"
  end

  needs :openmp if build.with? "openmp"

  def install
    args = std_cmake_args + %w[
      -Denable-glut=ON
      -Denable-gsl=ON
      -Denable-jpeg=ON
      -Denable-pdf=ON
      -Denable-python=OFF
      -Denable-octave=OFF
    ]

    args << "-Denable-openmp=" + (build.with?("openmp") ? "ON" : "OFF")
    args << "-Denable-pthread=" + (build.with?("openmp") ? "OFF" : "ON")
    args << "-Denable-qt5=ON"     if build.with? "qt"
    # the JSON samples need QtWebKit
    args << "-Denable-json-sample=OFF" if build.with? "qt"
    args << "-Denable-gif=ON"     if build.with? "giflib"
    args << "-Denable-hdf5_18=ON" if build.with? "hdf5"
    args << "-Denable-fltk=ON"    if build.with? "fltk"
    args << "-Denable-wx=ON"      if build.with? "wxmac"
    # Make sure macOS's GLUT.framework is used, not XQuartz or freeglut
    if OS.mac?
      glut_lib = "#{MacOS.sdk_path}/System/Library/Frameworks/GLUT.framework"
      args << "-DGLUT_glut_LIBRARY=#{glut_lib}"
    end
    args << ".."
    mkdir "brewery" do
      system "cmake", *args
      system "make", "install"
      cd "examples" do
        bin.install Dir["mgl*_example"]
      end
    end
  end

  test do
    system "#{bin}/mgl_example"
  end
end
