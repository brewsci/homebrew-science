class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"
  revision 3

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 sierra:       "05413886e413270ede03722ab12bc39642d5f22dd65cc5ea82c42efc0899c86a"
    sha256 el_capitan:   "67200fd6161da94bc4a1ce559903626e2f2a9f74e0c551eb7c041eefd6f5e4cc"
    sha256 yosemite:     "959e18dbb9c3b8905ade9e7b7bfb242d59936f6669e1b4468f5590106457ea58"
    sha256 x86_64_linux: "6365fddd62785b06b90d2182eaf04423f2e84f77e69cd86cf0e6154b26f944db"
  end

  depends_on "pkg-config" => :build
  depends_on "gcc" if OS.mac? # for gfortran
  depends_on "gsl"

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV.fortran
    system ENV.fc, "#{share}/examples/fgsl/fft.f90",
                   "-L#{lib}", "-lfgsl", "-I#{include}/fgsl", "-o", "test"
    system "./test"
  end
end
