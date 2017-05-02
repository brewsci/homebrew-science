class Fgsl < Formula
  desc "Fortran bindings for the GNU Scientific Library"
  homepage "http://www.lrz.de/services/software/mathematik/gsl/fortran/"
  url "http://www.lrz.de/services/software/mathematik/gsl/fortran/download/fgsl-1.2.0.tar.gz"
  sha256 "00fd467af2bb778e8d15ac8c27ddc7b9024bb8fa2f950a868d9d24b6086e5ca7"
  revision 1

  bottle do
    sha256 "b499806aac9c077261cca80d999e1d8a7c3f82de01d42d6b8740eae82b923691" => :sierra
    sha256 "c3116bc6bcf13b3a478d7cf0299cdb52fa3d275c1c2ed8fdac61feb21590654d" => :el_capitan
    sha256 "182bafda04a6356cb68c3d5f52d85e044c78c7a0e2b6a518cb046350f5044e60" => :yosemite
    sha256 "66740e57ff0f722085588d3d92ea2949068f944552897eed97b8f3446faf0e4b" => :x86_64_linux
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
