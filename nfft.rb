class Nfft < Formula
  desc "Nonequispaced fast Fourier transform"
  homepage "https://www-user.tu-chemnitz.de/~potts/nfft"
  url "https://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.2.3.tar.gz"
  sha256 "5c920f4be63230083756f36ad78bbdd083c4c2298ec361741dc74243c4d67818"

  bottle do
    cellar :any
    rebuild 1
    sha256 "84139f9d6ff8086294af900a96c0127c7622505da1545284017d5e7d0b34c84c" => :sierra
    sha256 "fb20ea3b10936307e4941509a097c78db2bb51e79d590f0a1002ee52cf1a9a6a" => :el_capitan
    sha256 "e7693f10ebff1091b248bf432165f9931cfa3086f1cdc4c6145b5025e621faa4" => :yosemite
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "fftw"

  needs :openmp if build.with? "openmp"

  fails_with :clang do
    build 425
    cause "Cannot compile complex compound assignment (works for >=503)"
  end

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]
    args << "--enable-openmp" if build.with? "openmp"
    system "./configure", *args
    system "make", "install"
    system "make", "check"
  end

  def caveats
    <<-EOS.undent
    NFFT is built as serial (not multi-threaded) library by default
    when being built with clang, as this compiler doesn't support
    OpenMP.

    A multi-threaded version of the NFFT library can be build with
    Homebrew's GNU C compiler, using

      brew install nfft --with-openmp

    which will create both serial and multi-threaded NFFT libraries.

    Linking against the serial libraries:

       ... -L#{opt_lib} -lnfft -lfftw3 ...

    Linking against the multi-threaded libraries (if built):

       ... -L#{opt_lib} -lnfft_threads -lfftw3_threads ...

    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nfft3.h>
      #include <nfft3util.h>

      int main()
      {
        nfft_plan p;
        int N=14;
        int M=19;
        nfft_init_1d(&p,N,M);
        nfft_vrand_shifted_unit_double(p.x,p.M_total);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnfft3", "-o", "test"
    system "./test"
  end
end
