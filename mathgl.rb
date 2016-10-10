class Mathgl < Formula
  def self.with_qt?(version)
    version.to_s == ARGV.value("with-qt")
  end

  def with_qt?(version)
    self.class.with_qt? version
  end

  desc "Scientific graphics library"
  homepage "http://mathgl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mathgl/mathgl/mathgl%202.3.5/mathgl-2.3.5.1.tar.gz"
  sha256 "77a56936f5a763fc03480c9c1fe8ed528a949b3d63b858c91abc21c731acf0db"
  revision 1

  bottle do
    sha256 "bb8bd47819fd2d94e67afb56bb1119b24abf16029d0c8a828c913d83c9cefda0" => :el_capitan
    sha256 "a6dfebc7ec6ce8ec0249d65be1e51940def38f479e5623bbb7f61de66a0fb2fb" => :yosemite
    sha256 "ccd995d632e808a82d55d2f566c451fe656b673b0ede83780e6dfe350633239e" => :mavericks
  end

  option "with-qt=", "Build with Qt 4 or 5 support"
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
  depends_on "qt"  if with_qt? 4
  depends_on "qt5" if with_qt? 5
  depends_on :x11  if build.with? "fltk"

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
    args << "-Denable-qt4=ON"     if with_qt? 4
    args << "-Denable-qt5=ON"     if with_qt? 5
    args << "-Denable-gif=ON"     if build.with? "giflib"
    args << "-Denable-hdf5_18=ON" if build.with? "hdf5"
    args << "-Denable-fltk=ON"    if build.with? "fltk"
    args << "-Denable-wx=ON"      if build.with? "wxmac"
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
