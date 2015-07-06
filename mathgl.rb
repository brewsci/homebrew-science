class Mathgl < Formula
  def self.with_qt?(version)
    version.to_s == ARGV.value("with-qt")
  end

  def with_qt?(version)
    self.class.with_qt? version
  end

  desc "Scientific graphics library"
  homepage "http://mathgl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mathgl/mathgl/mathgl%202.3.3/mathgl-2.3.3.tar.gz"
  sha256 "324fb8155223251f28afd3c7074d6930f09bb7a60c122c3e06af228a448d4fc9"

  bottle do
    sha256 "9ad89cbb3533fb0af7f64a2db88a255e260a5e6fd01162fa40087b946c669952" => :yosemite
    sha256 "5a1f45d39c3e25352c7d0d1647286a828ef07c8b62e4024cc4e0c3830f50efc2" => :mavericks
    sha256 "ee214a47e20725538eb3f4e85e7f868cfb7e9022be7e168dff914caf1be73b34" => :mountain_lion
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
    rm "ChangeLog" if File.exist? "ChangeLog" # rm this problematic symlink.
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
