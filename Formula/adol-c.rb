class AdolC < Formula
  desc "Automatic Differentiation by Overloading in C/C++"
  homepage "https://projects.coin-or.org/ADOL-C"
  url "https://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.6.3.tgz"
  sha256 "6ed74580695a0d2c960581e5430ebfcd380eb5da9337daf488bf2e89039e9c21"
  head "https://projects.coin-or.org/svn/ADOL-C/trunk/", :using => :svn

  bottle do
    sha256 "dd84e59f5fda4bba97bb7ca7457e8e6dc73f21a863150d4e38c262a8ad8ac775" => :high_sierra
    sha256 "0cc0d8caf1b150c4c30bb5f2d2b12238cc7e4812ce7985496d12a0d126ffec14" => :sierra
    sha256 "54ac19495b3550860969967cbb4e16946de178893da483d441a5ff934dc35bce" => :el_capitan
    sha256 "16d4410b5be94fcc331f729c2ec9c3e50a2e3aaa5efb0066b9b5c1e62b44dadc" => :x86_64_linux
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
