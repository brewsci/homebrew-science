class Mathgl < Formula
  desc "Scientific graphics library"
  homepage "http://mathgl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mathgl/mathgl/mathgl%202.3.5/mathgl-2.3.5.1.tar.gz"
  sha256 "77a56936f5a763fc03480c9c1fe8ed528a949b3d63b858c91abc21c731acf0db"
  revision 1

  bottle do
    rebuild 2
    sha256 "cd8b1ff95baac22a5b5331219e0d0f212a19128576f9e3a5c88da9cb7244daf5" => :sierra
    sha256 "634f39b085c405060360c49e20e6c7a6ae16edff4968b3edafd8fa695ef8d633" => :el_capitan
    sha256 "c04710e7554ea81460e08661fc3bbf2ae933dd74ab7748490fafc38c2cf33f9c" => :yosemite
    sha256 "92c874119052447912509f386d7e0a53df428192578f1e5e6f3d9c31f18b6b83" => :x86_64_linux
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
