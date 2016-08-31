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
    sha256 "4d52aedbf366e65172f4f1e4390e8ee9a045fd521ccc72a7b069c854f2e9d4da" => :el_capitan
    sha256 "1e1339d5fb9cea6eb4fbc6751289afe1c180017beaade40c5fa4ee9145660b94" => :yosemite
    sha256 "c068a86ef976268694fe0b6c89bd71fffaa293e649495cdad60dc19def2f8d4b" => :mavericks
  end

  option "with-qt=", "Build with Qt 4 or 5 support"

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

  def install
    args = std_cmake_args + %w[
      -Denable-glut=ON
      -Denable-gsl=ON
      -Denable-jpeg=ON
      -Denable-pthread=ON
      -Denable-pdf=ON
      -Denable-python=OFF
      -Denable-octave=OFF
    ]

    args << "-Denable-openmp=" + ((ENV.compiler == :clang) ? "OFF" : "ON")
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
