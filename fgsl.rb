class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "http://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "http://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.1.0.tar.gz"
  sha256 "18d45e2bf87695587cd83320777ada0d9e2dfdee43eb9d76e0dab660758aff47"

  bottle do
    sha256 "95cc9ed9c5adbf9d1c265c997f66b2f59ba39dfb74a97b8204cf1b81f177f2e0" => :el_capitan
    sha256 "15c17c47e769cd38aaaf16e3a53f42ac1925205af0ed9d1a16d240ad8cc3b9ca" => :yosemite
    sha256 "b2dcdaca96d46f3079cf266617e6a84f7d0072c72537788bdcf77cec14641f44" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on :fortran
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
