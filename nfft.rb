require 'formula'

class Nfft < Formula
  homepage 'http://www-user.tu-chemnitz.de/~potts/nfft'
  url 'http://www-user.tu-chemnitz.de/~potts/nfft/download/nfft-3.2.3.tar.gz'
  sha1 '9338cb0afbd5f4ddaf2bc5f9be5329ad61dc2ded'

  depends_on 'fftw'

  fails_with :clang do
    build 425
    cause "Cannot compile complex compound assignment (works for >=503)"
  end

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]
    system "./configure", *args
    system "make install"
    system "make check"
  end

  test do
    system "cat <<EOF > #{testpath}/test.c
      #include <nfft3.h>

      int main() {
        nfft_plan p;
        int N=14;
        int M=19;
        nfft_init_1d(&p,N,M);
        nfft_vrand_shifted_unit_double(p.x,p.M_total);
      }
EOF"
    system "${CC} -o #{testpath}/a.out #{testpath}/test.c -lnfft3"
  end

end
