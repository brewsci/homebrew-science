class Gnudatalanguage < Formula
  desc "A free and open-source IDL/PV-WAVE compiler"
  homepage "http://gnudatalanguage.sourceforge.net"
  url "https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.5/gdl-0.9.5.tar.gz"
  sha256 "cc9635e836b5ea456cad93f8a07d589aed8649668fbd14c4aad22091991137e2"
  revision 2

  bottle do
    sha256 "f0cd1ed7bb896d4997cb46ab95f9d24bf679ad445af46b2b2eadc0848512cda1" => :yosemite
    sha256 "a70e346d02a83c18df4f02cffcdbaa81eb59ae5be460495c3ff14fdc0ce5fe45" => :mavericks
    sha256 "a39bce8d89f0beb638584e4c0c60bd2e0a6d4ff3a8b8b1d4597e8d073374cc77" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "plplot" => "with-x11"
  depends_on "gsl"
  depends_on "readline"
  depends_on "graphicsmagick"
  depends_on "netcdf"
  depends_on "homebrew/versions/hdf4" => :optional
  depends_on "hdf5"
  depends_on "libpng"
  depends_on "udunits"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "eigen"
  depends_on :x11
  depends_on :python => :optional

  # part 1 taken from macports https://trac.macports.org/browser/trunk/dports/math/gnudatalanguage/files/patch-CMakeLists.txt.diff
  # other parts taken from https://github.com/freebsd/freebsd-ports/tree/master/science/gnudatalanguage/files
  patch :p0 do
    url "https://gist.githubusercontent.com/iml/ee107290ee5cd2850190/raw/83c046bce9facda8c560a8d38ea02913892c4b88/gnudatalanguage.diff"
    sha256 "b2e9b2c1ed51676e048441b7bfc160488fdf5898b1d1c9396bc58eb85996981e"
  end

  # restores compatibility with latest plplot. Patch found upstream at http://sourceforge.net/p/gnudatalanguage/bugs/643/
  patch do
    url "https://gist.github.com/tschoonj/e01c72165fd2cb9a68c9/raw/5143168a04de0d4f8fc6c3621733ce68fe7c6268/gdl-plplot.patch"
    sha256 "937e82f6052aa72576df49046aa57d03593c7ba21d074f2455cd614318b881dd"
  end

  def install
    args = std_cmake_args
    args << "-DHDF=OFF" if build.without?("hdf4")
    args << "-DPYTHON=OFF" if build.without?("python")
    args << "-DWXWIDGETS=OFF" << "-DPSLIB=OFF"
    system "cmake", ".", *args
    system "make"
    # several tests fail
    # system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/gdl", "--version"
  end
end
