class Octave < Formula
  desc "a high-level interpreted language for numerical computations."
  homepage "https://www.gnu.org/software/octave/index.html"
  url "http://ftpmirror.gnu.org/octave/octave-4.0.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/octave/octave-4.0.0.tar.gz"
  sha256 "4c7ee0957f5dd877e3feb9dfe07ad5f39b311f9373932f0d2a289dc97cca3280"
  head "http://www.octave.org/hg/octave", :branch => "default", :using => :hg

  bottle do
    sha256 "98d8a35cd7c4e20e13b77e6999bc75a39ef52f8e5fa6deafd80f60e10c8db8d0" => :yosemite
    sha256 "0a28985e322d56002755469a22cc5ae3c487c191d35c8b5b3b25c34abcc0b2cb" => :mavericks
    sha256 "35344dafa1cb05d8d7d1c77c469e012d404b0a5062c840ed062570c94fce3d2b" => :mountain_lion
  end

  stable do
    # Fix compilation of classdef with the clang compiler (bug #41178)
    # See: http://savannah.gnu.org/bugs/?41178
    patch do
      url "http://savannah.gnu.org/support/download.php?file_id=34691"
      sha256 "25a9c0b937b50de0acb4dc50e4d6d285ef54f1673e4b84530b53effe983bdd88"
    end
  end

  patch :DATA

  skip_clean "share/info" # Keep the docs

  # essential dependencies
  depends_on :fortran
  depends_on "pcre"

  # options, enabled by default
  option "without-check",          "Do not perform build-time tests (not recommended)"
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-docs",           "Do not build documentation"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-glpk",           "Do not use GLPK"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  # options, disabled by default
  option "with-gui",               "Use the graphical user interface (still buggy)"
  option "with-jit",               "Use the experimental JIT support (not recommended)"
  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "with-osmesa",            "Use the OSmesa library (not recommended)"

  # build dependencies
  depends_on "gnu-sed"        => :build
  depends_on "pkg-config"     => :build
  depends_on "texinfo"        => :build if build.with?("docs") && OS.linux?

  # gui dependencies
  if build.with? "gui"
    depends_on "qscintilla2"
    depends_on "qt"
  end

  # dependencies needed for development build
  head do
    depends_on "autoconf"     => :build
    depends_on "automake"     => :build
    depends_on "bison"        => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "librsvg"      => :build
  end

  # recommended dependencies
  depends_on "suite-sparse421" => :recommended
  depends_on "readline"        => :recommended
  depends_on "arpack"          => :recommended
  depends_on "epstool"         => :recommended
  depends_on "fftw"            => :recommended
  depends_on "ghostscript"     => :recommended  # ps/pdf image output
  depends_on "glpk"            => :recommended
  depends_on "gl2ps"           => :recommended
  depends_on "gnuplot"         => :recommended
  depends_on "graphicsmagick"  => :recommended  # imread/imwrite
  depends_on "hdf5"            => :recommended
  depends_on :java             => :recommended
  depends_on "qhull"           => :recommended
  depends_on "qrupdate"        => :recommended

  # conditional dependecies
  depends_on "curl"           if build.with?("curl") && MacOS.version == :leopard
  depends_on "llvm"           if build.with? "jit"
  depends_on "pstoedit"       if build.with? "ghostscript"

  # optional dependencies
  depends_on "openblas"       => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline" if build.with? "readline"

    # basic arguments
    args = ["--prefix=#{prefix}"]
    args << "--enable-dependency-tracking"
    args << "--enable-link-all-dependencies"
    args << "--enable-shared"

    # arguments, enabled by default
    args << "--disable-docs"     if build.without? "docs"
    args << "--disable-java"     if build.without? "java"
    args << "--disable-gui"      if build.without? "gui"
    args << "--disable-readline" if build.without? "readline"
    args << "--disable-static"
    args << "--with-x=no"        if OS.mac? # We don't need X11 for Mac at all
    args << "--without-curl"     if build.without? "curl"
    args << "--without-fftw3"    if build.without? "fftw"
    args << "--without-glpk"     if build.without? "glpk"
    args << "--without-hdf5"     if build.without? "hdf5"
    args << "--without-qhull"    if build.without? "qhull"
    args << "--without-qrupdate" if build.without? "qrupdate"
    args << "--without-zlib"     if build.without? "zlib"

    # arguments, disabled by default
    args << "--enable-jit"       if build.with?    "jit"
    args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas" if build.with? "openblas"
    args << "--without-OSMesa"   if build.without? "osmesa"

    # arguments if building without suite-sparse
    if build.without? "suite-sparse"
      args << "--without-amd"
      args << "--without-camd"
      args << "--without-colamd"
      args << "--without-ccolamd"
      args << "--without-cxsparse"
      args << "--without-camd"
      args << "--without-cholmod"
      args << "--without-umfpack"
    else
      ENV.append_to_cflags "-L#{Formula["metis4"].opt_lib} -lmetis" if Tab.for_name("suite-sparse421").with? "metis4"
    end

    system "./bootstrap" if build.head?

    # Libtool needs to see -framework to handle dependencies better.
    inreplace "configure", "-Wl,-framework -Wl,", "-framework "

    # The Mac build configuration passes all linker flags to mkoctfile to
    # be inserted into every oct/mex build. This is actually unnecessary and
    # can cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    system "./configure", *args
    system "make", "all", "ICOTOOL=true" #do not complain about missing icotool
    system "make check 2>&1 | tee make-check.log" if build.with? "check"
    system "make", "install"
    prefix.install "make-check.log" if File.exist? "make-check.log"
    prefix.install "test/fntests.log" if File.exist? "test/fntests.log"
  end

  test do
    system "octave", "--eval", "(22/7 - pi)/pi"
  end

  def caveats
    s = ""

    if build.with? "gui"
      s += <<-EOS.undent

      The graphical user interface is now used when running Octave interactively.
      The start-up option --no-gui will run the familiar command line interface, and
      still allows use of the GUI dialogs and qt plotting toolkit.
      The option --no-gui-libs runs a minimalist command line interface that does not
      link with the Qt libraries and uses the fltk toolkit for plotting.

      EOS

    else

      s += <<-EOS.undent

      The graphical user interface is disabled by default since it is still buggy on
      OS X; use brew with the option --with-gui to enable it.

      EOS

    end

    if build.with? "gnuplot"
      s += <<-EOS.undent

        Octave was compiled with gnuplot; enable it via graphics_toolkit('gnuplot').
        All graphics terminals can be used by setting the environment variable GNUTERM
        in ~/.octaverc, and building gnuplot with the matching options.

          setenv('GNUTERM','qt')    # Default graphics terminal with Octave GUI
          setenv('GNUTERM','x11')   # Requires XQuartz; install gnuplot --with-x
          setenv('GNUTERM','wxt')   # wxWidgets/pango; install gnuplot --wx
          setenv('GNUTERM','aqua')  # Requires AquaTerm; install gnuplot --with-aquaterm

          You may also set this variable from within Octave.

      EOS
    end

    logfile = "#{prefix}/make-check.log"
    if File.exist? logfile
      logs = `grep 'libinterp/array/.*FAIL \\d' #{logfile}`
      unless logs.empty?
        s += <<-EOS.undent

            Octave's self-tests for this installation produced the following failues:
            --------
        EOS
        s += logs + <<-EOS.undent
            --------
            These failures indicate a conflict between Octave and its BLAS-related
            dependencies. You can likely correct these by removing and reinstalling
            arpack, qrupdate, suite-sparse421, and octave. Please use the same BLAS
            settings for all (i.e., with the default, or "--with-openblas").
        EOS
      end
    end

    s += "\n" unless s.empty?
    s
  end
end

__END__
diff -ur a/liboctave/operators/libcxx-fix.h b/liboctave/operators/libcxx-fix.h
--- /dev/null	2015-05-23 16:21:53.000000000 +0200
+++ b/liboctave/operators/libcxx-fix.h	2015-07-25 11:23:50.000000000 +0200
@@ -0,0 +1,69 @@
+#ifndef _LIBCPP_VERSION
+#error "for libc++ only"
+#endif
+
+namespace libcxx_fix {
+
+using std::is_integral;
+using std::is_same;
+using std::enable_if;
+
+template <class _Tp, class _Tn = void>
+struct numeric_type
+{
+    typedef void type;
+    static const bool value = false;
+};
+
+template <class _Tp>
+struct numeric_type<_Tp, typename enable_if<is_integral<_Tp>::value ||
+                                            is_same<_Tp, double>::value>::type>
+{
+    typedef double type;
+    static const bool value = true;
+};
+
+template <class _Tp>
+struct numeric_type<_Tp, typename enable_if<is_same<_Tp, long double>::value ||
+                                            is_same<_Tp, float>::value>::type>
+{
+    typedef _Tp type;
+    static const bool value = true;
+};
+
+template <>
+struct numeric_type<void, void>
+{
+    static const bool value = true;
+};
+
+template <class _A1, class _A2,
+          bool = numeric_type<_A1>::value &&
+                 numeric_type<_A2>::value>
+class promote
+{};
+
+template <class _A1, class _A2>
+class promote<_A1, _A2, true>
+{
+private:
+    typedef typename numeric_type<_A1>::type __type1;
+    typedef typename numeric_type<_A2>::type __type2;
+public:
+    typedef decltype(__type1() + __type2()) type;
+};
+
+template <class _A1, class _A2>
+inline _LIBCPP_INLINE_VISIBILITY
+typename promote<_A1, _A2>::type
+pow(_A1 __x, _A2 __y) _NOEXCEPT
+{
+    typedef typename promote<_A1, _A2>::type __result_type;
+#if _LIBCPP_STD_VER > 11
+    static_assert((!(is_same<_A1, __result_type>::value &&
+                     is_same<_A2, __result_type>::value)), "");
+#endif
+    return ::pow(static_cast<__result_type>(__x), static_cast<__result_type>(__y));
+}
+
+}
diff -ur a/libinterp/corefcn/comment-list.h b/libinterp/corefcn/comment-list.h
--- a/libinterp/corefcn/comment-list.h	2015-05-23 16:21:53.000000000 +0200
+++ b/libinterp/corefcn/comment-list.h	2015-07-25 11:23:50.000000000 +0200
@@ -25,7 +25,7 @@
 
 #include <string>
 
-#include <base-list.h>
+#include "base-list.h"
 
 extern std::string get_comment_text (void);
 
diff -ur a/libinterp/corefcn/oct.h b/libinterp/corefcn/oct.h
--- a/libinterp/corefcn/oct.h	2015-05-23 16:21:53.000000000 +0200
+++ b/libinterp/corefcn/oct.h	2015-07-25 11:24:22.000000000 +0200
@@ -28,7 +28,7 @@
 // config.h needs to be first because it includes #defines that can */
 // affect other header files.
 
-#include <config.h>
+#include "config.h"

 #include "Matrix.h"

diff -ur a/liboctave/Makefile.in b/liboctave/Makefile.in
--- a/liboctave/Makefile.in	2015-05-26 18:21:48.000000000 +0200
+++ b/liboctave/Makefile.in	2015-07-25 11:21:34.000000000 +0200
@@ -3864,7 +3864,8 @@
   operators/Sparse-diag-op-defs.h \
   operators/Sparse-op-decls.h \
   operators/Sparse-op-defs.h \
-  operators/Sparse-perm-op-defs.h
+  operators/Sparse-perm-op-defs.h \
+  operators/libcxx-fix.h

 OPERATORS_SRC =
 OP_SRCDIR = $(abs_top_srcdir)/liboctave/operators
diff -ur a/liboctave/operators/module.mk b/liboctave/operators/module.mk
--- a/liboctave/operators/module.mk	2015-05-23 16:21:53.000000000 +0200
+++ b/liboctave/operators/module.mk	2015-07-25 11:20:50.000000000 +0200
@@ -35,7 +35,8 @@
   operators/Sparse-diag-op-defs.h \
   operators/Sparse-op-decls.h \
   operators/Sparse-op-defs.h \
-  operators/Sparse-perm-op-defs.h
+  operators/Sparse-perm-op-defs.h \
+  operators/libcxx-fix.h

 ## There are no distributed source files in this directory
 OPERATORS_SRC =
diff -ur a/liboctave/operators/mx-inlines.cc b/liboctave/operators/mx-inlines.cc
--- a/liboctave/operators/mx-inlines.cc	2015-05-23 16:21:53.000000000 +0200
+++ b/liboctave/operators/mx-inlines.cc	2015-07-25 11:23:11.000000000 +0200
@@ -307,7 +307,13 @@

 // Let the compiler decide which pow to use, whichever best matches the
 // arguments provided.
+#if defined(_LIBCPP_VERSION) && (_LIBCPP_VERSION >= 1101)
+// Workaround http://llvm.org/bugs/show_bug.cgi?id=21083
+#include "libcxx-fix.h"
+using libcxx_fix::pow;
+#else
 using std::pow;
+#endif
 DEFMXMAPPER2X (mx_inline_pow, pow)

 // Arbitrary function appliers. The function is a template parameter to enable
