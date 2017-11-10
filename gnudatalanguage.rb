class Gnudatalanguage < Formula
  desc "Free and open-source IDL/PV-WAVE compiler"
  homepage "https://gnudatalanguage.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gnudatalanguage/gdl/0.9.7/gdl-0.9.7.tgz"
  sha256 "2b5945d06e4d95f01cb70a3c432ac2fa4c81e1b3ac7c02687a6704ab042a7e21"
  revision 4

  bottle :disable, "needs to be rebuilt with latest netcdf"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gsl"
  depends_on "readline"
  depends_on "graphicsmagick"
  depends_on "netcdf"
  depends_on "hdf5"
  depends_on "libpng"
  depends_on "udunits"
  depends_on "gsl"
  depends_on "fftw"
  depends_on "eigen"
  depends_on :x11
  depends_on :python => :optional

  # Supplementary dependencies for plplot
  depends_on "cairo"
  depends_on "pango"
  depends_on "freetype"
  depends_on "libtool" => :run

  conflicts_with "plplot", :because => "both install a pltek executable"

  fails_with :gcc => "5" unless OS.mac?

  # Support HDF5 1.10. See https://bugs.debian.org/841971
  patch do
    url "https://gist.githubusercontent.com/sjackman/00fb95e10b7775d16924efb6faf462f6/raw/71ed3e05138a20b824c9e68707e403afc0f92c98/gnudatalanguage-hdf5-1.10.patch"
    sha256 "8400c3c17ac87704540a302673563c1e417801e729e3460f1565b8cd1ef9fc9d"
  end

  resource "plplot-x11" do
    url "https://downloads.sourceforge.net/project/plplot/plplot/5.12.0%20Source/plplot-5.12.0.tar.gz"
    sha256 "8dc5da5ef80e4e19993d4c3ef2a84a24cc0e44a5dade83201fca7160a6d352ce"
  end

  def install
    resource("plplot-x11").stage do
      args = std_cmake_args
      args << "-DPLD_xwin=ON"
      args += %w[
        -DENABLE_ada=OFF
        -DENABLE_d=OFF
        -DENABLE_qt=OFF
        -DENABLE_lua=OFF
        -DENABLE_tk=OFF
        -DENABLE_python=OFF
        -DENABLE_tcl=OFF
        -DPLD_xcairo=OFF
        -DPLD_wxwidgets=OFF
        -DENABLE_wxwidgets=OFF
        -DENABLE_java=OFF
        -DENABLE_f95=OFF
      ]

      mkdir "plplot-build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    mkdir "build" do
      args = std_cmake_args
      args << "-DHDF=OFF" # Disables hdf4
      args << "-DPYTHON=OFF" if build.without?("python")
      args << "-DWXWIDGETS=OFF" << "-DPSLIB=OFF"
      system "cmake", "..", *args
      system "make"

      # The following tests FAILED:
      #    80 - test_execute.pro (Failed)
      #    84 - test_fft_leak.pro (Failed)
      #   108 - test_image_statistics.pro (Failed)
      #   128 - test_obj_isa.pro (Failed)
      # Reported 3 Feb 2017 https://sourceforge.net/p/gnudatalanguage/bugs/716/
      # system "make", "check"

      system "make", "install"
    end
  end

  test do
    system "#{bin}/gdl", "--version"
  end
end
