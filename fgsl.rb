class Fgsl < Formula
  homepage "http://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "http://www.lrz.de/services/software/mathematik/gsl/fortran/fgsl-1.0.0.tar.gz"
  sha1 "f39362bd4d0c2daf8382d8ec818bb166ae5a7dea"
  revision 1

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "5056b6160e68259055c51680934e4f0039728300f4dcd6224d8f09a0f73c520d" => :yosemite
    sha256 "57a6c6e3a4337d520e1ff588a0e2c2c8b5df80c32260bd443019b709a660bfa7" => :mavericks
    sha256 "c17e3285cf8099aec32622baa70dcbb66e27c840641738cd8b0d0f7a134c1603" => :mountain_lion
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
