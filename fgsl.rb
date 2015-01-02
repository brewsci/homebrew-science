class Fgsl < Formula
  homepage "http://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "http://www.lrz.de/services/software/mathematik/gsl/fortran/fgsl-1.0.0.tar.gz"
  sha1 "f39362bd4d0c2daf8382d8ec818bb166ae5a7dea"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "be4fa1734a0f0dc960f5856767c3d4cd1ee4df45" => :yosemite
    sha1 "e2923d74d33b2dac361d861411882c80700625b1" => :mavericks
    sha1 "820bb9eeb5a3c783dedf2522cdcba89b31ec2c9d" => :mountain_lion
  end

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
    system ENV.fc, "#{share}/examples/fgsl/fft.f90",
                   "-L#{lib}", "-lfgsl", "-I#{include}/fgsl", "-o", "test"
    system "./test"
  end
end
