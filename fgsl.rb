class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"
  revision 2

  bottle do
    sha256 "bba80c3e3daf5f89ab054b65e271e7813a57c3fac1e691c7bff67ed9eecba739" => :sierra
    sha256 "1d6330984c0a307f074b954ae1095ff80c827df2b5b7e89679fd5857c4e00f49" => :el_capitan
    sha256 "1413cf925afd495793f057ae666cb6b0d88121aafcf09042fbf32b39d3d4475f" => :yosemite
    sha256 "231da62572cce81380c9e2589cd1557f56421c46f277a4cc39086472b58a0d2e" => :x86_64_linux
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
