class Fgsl < Formula
  homepage "http://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "http://www.lrz.de/services/software/mathematik/gsl/fortran/fgsl-1.0.0.tar.gz"
  sha1 "f39362bd4d0c2daf8382d8ec818bb166ae5a7dea"

  depends_on :fortran
  depends_on "gsl"
  depends_on "pkg-config" => :build
  option "without-check", "Disable build-time checking (not recommended)"

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end
  test do
    ENV.fortran
    system ENV.fc, "#{prefix}/share/examples/fgsl/fft.f90", "-L#{prefix}/lib", "-lfgsl" ,
    "-I#{prefix}/include/fgsl", "-o", "test"
    system "./test"
  end
end
