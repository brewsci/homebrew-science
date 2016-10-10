class AdolC < Formula
  desc "Automatic Differentiation by Overloading in C/C++"
  homepage "https://projects.coin-or.org/ADOL-C"
  url "http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.6.2.tgz"
  sha256 "f6326e7ba994d02074816132d4461915221069267c31862b31fab7020965c658"
  head "https://projects.coin-or.org/svn/ADOL-C/trunk/", :using => :svn

  bottle do
    sha256 "e3a9fae09a42da6c59a785cae6893b837b2bf81014ae5930524e3c04c7881d1c" => :sierra
    sha256 "a355e3ef09468dd53164a0001902ccf5b5e3676987ec6ba45dda102a16583f79" => :el_capitan
    sha256 "3811346b9efaf44e4e8d735efa03b32d8152345f580f4733360c6a7886796524" => :yosemite
  end

  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  colpack_opts = []
  colpack_opts << "with-openmp" if build.with? "openmp"
  depends_on "colpack" => [:recommended] + colpack_opts

  needs :cxx11
  needs :openmp if build.with? "openmp"

  def install
    ENV.cxx11

    # Configure may get automatically regenerated. So patch configure.ac.
    inreplace %w[configure configure.ac], "lib64", "lib"

    args =  ["--prefix=#{prefix}", "--enable-sparse"]
    args << "--with-colpack=#{Formula["colpack"].opt_prefix}" if build.with? "colpack"
    args << "--enable-ulong" if MacOS.prefer_64_bit?

    ENV.append_to_cflags "-I#{buildpath}/ADOL-C/include/adolc"
    system "./configure", *args
    system "make", "install"
    system "make", "test"

    # move config.h to include as some packages require this info
    (include/"adolc").install "ADOL-C/src/config.h"
    doc.install "ADOL-C/doc/adolc-manual.pdf"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <adolc/adouble.h>
      #include <adolc/drivers/drivers.h>
      #include <adolc/taping.h>
      int main(void) {
        int n = 10, i, j;
        size_t tape_stats[STAT_SIZE];
        double* xp = new double[n];
        double  yp = 0.0;
        adouble* x = new adouble[n];
        adouble  y = 1;
        for (i = 0; i < n; i++)
          xp[i] = (i + 1.0) / (2.0 + i);
        trace_on(1);
        for (i = 0; i < n; i++) {
            x[i] <<= xp[i];
            y *= x[i];
        }
        y >>= yp;
        delete[] x;
        trace_off();
        tapestats(1, tape_stats);
        double* g = new double[n];
        gradient(1, n, xp, g);
        double** H = (double**)malloc(n * sizeof(double*));
        for (i = 0; i < n; i++)
          H[i] = (double*)malloc((i+1) * sizeof(double));
        hessian(1, n, xp, H);
        double errg = 0;
        double errh = 0;
        for (i = 0; i < n; i++)
          errg += fabs(g[i] - yp / xp[i]);
        for (i = 0; i < n; i++)
          for (j = 0; j < n; j++)
            if (i > j)
              errh += fabs(H[i][j] - g[i] / xp[j]);
        for (i = 0; i < n; i++)
          free(H[i]);
        free(H);
        cout << yp - 1 / (1.0 + n) << "\\n";
        cout << errg << "\\n";
        cout << errh << "\\n";
        return 0;
      }
    EOS
    ENV.cxx11
    cxx_with_args = ENV.cxx.split + %W[
      test.cpp
      -I#{opt_include}
      -o test
      -L#{opt_lib} -ladolc
      -L#{Formula["colpack"].opt_lib} -lColPack
    ]
    system *cxx_with_args
    output = `./test`.split
    output.each { |val| assert val.to_f < 1.0e-8 }
  end
end
