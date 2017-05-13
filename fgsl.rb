class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "https://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "https://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"
  revision 2

  bottle do
    sha256 "16c3313848afc30d4926abdc248d46eb2a2d12ae4363b88b595f4f1780d50591" => :sierra
    sha256 "c69725dca9c2803c57b095ac779bf160d4f0069e4c8368503b31444a5c116a27" => :el_capitan
    sha256 "d1b375f6c8e045bc33205647fd4c26d2511ec961295ab2ab5dac5ba5c6f676ff" => :yosemite
    sha256 "ed82f035a924f89b178c5877a1dbd572b51f27e58aa58ee6cd96bc0f6eb5db59" => :x86_64_linux
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
