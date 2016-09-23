class AdolC < Formula
  desc "Automatic Differentiation by Overloading in C/C++"
  homepage "https://projects.coin-or.org/ADOL-C"
  url "http://www.coin-or.org/download/source/ADOL-C/ADOL-C-2.6.1.tgz"
  sha256 "037089e0f64224e5e6255b61af4fe7faac080533fd778b76fe946e52491918b5"
  head "https://projects.coin-or.org/svn/ADOL-C/trunk/", using: :svn

  bottle do
    sha256 "28d6ecbb9850d385a8ef1908efe899418a823316eaea312a9a2226a93077b91d" => :el_capitan
    sha256 "022eb673f740a2ba680967e17200c8d3fb576255c627b21c9d257447b257a8d5" => :yosemite
    sha256 "13232252782d0b91386bef40a72580b36bb430a441e31b24ecb9ae8151821c3f" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "colpack" => :recommended

  needs :cxx11

  def install
    ENV.cxx11

    # Configure may get automatically regenerated. So patch configure.ac.
    inreplace %w[configure configure.ac], "lib64", "lib"

    args =  ["--prefix=#{prefix}", "--enable-sparse"]
    args << "--with-colpack=#{Formula["colpack"].opt_prefix}" if build.with? "colpack"
    args << "--with-openmp-flag=-fopenmp" if ENV.compiler != :clang
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
