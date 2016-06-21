class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "http://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "http://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.0.0.tar.gz"
  sha256 "2841f6deb2ce05e153fc1d89fe5e46aba74c60a2595c857cef9ca771a0cf6290"
  revision 1

  bottle do
    revision 1
    sha256 "dfcbf89d2e98d2dc64727145161c340e2f9b9ca014a31c6678674a2042de1e40" => :el_capitan
    sha256 "2c69df36a48f057e10403b6ff2a87564698479eed6afb7ce1b84abb9379fdcf2" => :yosemite
    sha256 "bf3b6f0c6a8deb62c8f2ea15eb239fd64238e54cfad8f370abf38052b4ebf2cc" => :mavericks
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
