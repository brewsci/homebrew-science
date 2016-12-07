class Mathgl < Formula
  desc "Scientific graphics library"
  homepage "http://mathgl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mathgl/mathgl/mathgl%202.3.5/mathgl-2.3.5.1.tar.gz"
  sha256 "77a56936f5a763fc03480c9c1fe8ed528a949b3d63b858c91abc21c731acf0db"
  revision 1

  bottle do
    rebuild 1
    sha256 "e06de4dbea3ab70573ad75ed9c02600636bbd30dfd60c0f3a741f01b3ccff936" => :sierra
    sha256 "ac6f341a614e8b38f4a6b879b55fc6f18d900b514db98cc85fc3746d126e1c47" => :el_capitan
    sha256 "4abd73a027a09970f2324ad92dc31aa642346e6c600bf29cb7787bc47b451c0c" => :yosemite
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
  depends_on "qt5" => :optional
  depends_on :x11  if build.with? "fltk"

  if OS.linux?
    depends_on "linuxbrew/xorg/xorg"
    depends_on "homebrew/x11/freeglut"
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

    args << "-Denable-openmp=" + ((build.with? "openmp") ? "ON" : "OFF")
    args << "-Denable-pthread=" + ((build.with? "openmp") ? "OFF" : "ON")
    args << "-Denable-qt5=ON"     if build.with? "qt5"
    # the JSON samples need QtWebKit
    args << "-Denable-json-sample=OFF" if build.with? "qt5"
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
