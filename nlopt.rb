class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "http://ab-initio.mit.edu/nlopt"
  url "http://ab-initio.mit.edu/nlopt/nlopt-2.4.2.tar.gz"
  sha256 "8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89"
  revision 2
  head "https://github.com/stevengj/nlopt.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4c1bfd654be7c344c1ebb6e86dea50063305cdf8f3ac1cf7e55c28371ce87ffd" => :sierra
    sha256 "86ec755243d199111edfc425db9c3f3e8b4c3cef6b346bea7408361f742c96bc" => :el_capitan
    sha256 "adac1b7dc1111703dda1e01b0a0a6cb7cdea9b211d51f9a9f6c055b4763babd1" => :yosemite
  end

  option "with-python", "Build Python bindings (requires NumPy)"

  depends_on :python => "numpy" if build.with? "python"
  depends_on "octave" => :optional
  depends_on "swig" if build.head?
  depends_on "cmake" => :build if build.head?
  depends_on "guile" => :optional if build.head?

  def install
    ENV.deparallelize

    if build.head?
      args = [
        "-DWITH_CXX=ON",
        "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      ]
      args << "-DBUILD_MATLAB=OFF" if build.without? "matlab"
      args << "-DBUILD_PYTHON=OFF" if build.without? "python"
      args << "-DBUILD_OCTAVE=OFF" if build.without? "octave"
      system "cmake", ".", *args
    else
      if build.with? "octave"
        ENV["OCT_INSTALL_DIR"] = pkgshare/"oct"
        ENV["M_INSTALL_DIR"] = pkgshare/"m"
        ENV["MKOCTFILE"] = "#{Formula["octave"].opt_bin}/mkoctfile"
      end
      args = [
        "--prefix=#{prefix}",
        "--with-cxx",
        "--enable-shared",
      ]
      args << "--without-octave" if build.without? "octave"
      args << "--without-python" if build.without? "python"
      system "./configure", *args
      system "make"
    end
    system "make", "install"

    # Create lib links for C programs
    lib.install_symlink lib/"libnlopt_cxx.0.dylib" => lib/"libnlopt.0.dylib"
    lib.install_symlink lib/"libnlopt_cxx.dylib" => lib/"libnlopt.dylib"
    lib.install_symlink lib/"libnlopt_cxx.a" => lib/"libnlopt.a"
  end

  def caveats
    s = ""
    if build.with? "octave"
      s += <<-EOS.undent
      Please add
        #{pkgshare}/oct
      and
        #{pkgshare}/m
      to the Octave path.
      EOS
    end
    if build.with? "python"
      python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
      s += <<-EOS.undent
      Please add
        #{lib}/python#{python_version}/site-packages
      to the Python path.
      EOS
    end
    s
  end

  test do
    # Based on http://ab-initio.mit.edu/wiki/index.php/NLopt_Tutorial#Example_in_C.2FC.2B.2B
    (testpath/"test.c").write <<-EOS.undent
    #include <math.h>
    #include <nlopt.h>
    #include <stdio.h>
    double myfunc(unsigned n, const double *x, double *grad, void *my_func_data)
    {
      if (grad) {
        grad[0] = 0.0;
        grad[1] = 0.5 / sqrt(x[1]);
      }
      return sqrt(x[1]);
    }
    typedef struct {
      double a, b;
    } my_constraint_data;
    double myconstraint(unsigned n, const double *x, double *grad, void *data)
    {
      my_constraint_data *d = (my_constraint_data *) data;
      double a = d->a, b = d->b;
      if (grad) {
        grad[0] = 3 * a * (a*x[0] + b) * (a*x[0] + b);
        grad[1] = -1.0;
      }
      return ((a*x[0] + b) * (a*x[0] + b) * (a*x[0] + b) - x[1]);
     }
     int main() {
      double lb[2] = { -HUGE_VAL, 0 }; /* lower bounds */
      nlopt_opt opt;
      opt = nlopt_create(NLOPT_LD_MMA, 2); /* algorithm and dimensionality */
      nlopt_set_lower_bounds(opt, lb);
      nlopt_set_min_objective(opt, myfunc, NULL);
      my_constraint_data data[2] = { {2,0}, {-1,1} };
      nlopt_add_inequality_constraint(opt, myconstraint, &data[0], 1e-8);
      nlopt_add_inequality_constraint(opt, myconstraint, &data[1], 1e-8);
      nlopt_set_xtol_rel(opt, 1e-4);
      double x[2] = { 1.234, 5.678 };  /* some initial guess */
      double minf; /* the minimum objective value, upon return */

      if (nlopt_optimize(opt, x, &minf) < 0) {
        printf("nlopt failed!");
        return 1;
      }
      else {
        printf("found minimum at f(%g,%g) = %0.10g", x[0], x[1], minf);
        return 0;
      }
      nlopt_destroy(opt);
    }
    EOS
    system ENV.cxx, "test.c", "-o", "test", "-lnlopt", "-lm"
    system "./test"
  end
end
