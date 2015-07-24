class Octave < Formula
  desc "a high-level interpreted language for numerical computations."
  homepage "https://www.gnu.org/software/octave/index.html"
  url "http://ftpmirror.gnu.org/octave/octave-3.8.2.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/octave/octave-3.8.2.tar.bz2"
  sha256 "83bbd701aab04e7e57d0d5b8373dd54719bebb64ce0a850e69bf3d7454f33bae"
  head "http://www.octave.org/hg/octave", :branch => "default", :using => :hg
  revision 1

  stable do
    # Allows clang 3.5 to compile with a recent libc++ release.
    # See: https://savannah.gnu.org/bugs/?43298
    patch do
      url "https://gist.github.com/tchaikov/6ce5f697055b0756126a/raw/4fc94a1fa1d5b032f8586ce3ab0015b04351426f/octave-clang3.5-fix.patch"
      sha1 "6e5c0d8f6b07803152c8a1caad39a113fc8b8d0a"
    end
  end

  bottle do
    revision 1
    sha256 "0b0fadeefbb7bf3d078b73a1fcaad8e64d4e7319dfb256a34e39d402fa1fb83c" => :yosemite
    sha256 "ea4536731e805befcd627aea4abab646c1e6a4621280d74f025836c44d0cb1b3" => :mavericks
    sha256 "65754b67ca1deed994cc1a538c63b00ae6dc6c6f12f0995a1417b7a7e6a4ff7a" => :mountain_lion
  end

  head do
    # Allows clang 3.5 to compile with a recent libc++ release.
    # See: https://savannah.gnu.org/bugs/?43298
    patch do
      url "https://gist.github.com/schoeps/ec25b19bf30f97d33cdb/raw/6f164415e5e0fb556c1cfc2b039985d25dfad872/octave-clang3.5-fix.patch"
      sha1 "c3209b0bebd69ff5b9fa2d0463c8034d53f99225"
    end
  end

  # Allows mkoctfile to process "-framework vecLib" properly.
  # See: https://savannah.gnu.org/bugs/?42002
  patch do
    url "https://savannah.gnu.org/patch/download.php?file_id=31072"
    sha1 "19f2dcaf636f1968c4b1639797415f83fb21d5a3"
  end

  # Allows other software to interface Octave and find its headers.
  # See: https://github.com/shogun-toolbox/shogun/issues/2396
  patch :DATA

  skip_clean "share/info" # Keep the docs

  option "without-check",          "Skip build-time tests (not recommended)"
  option "without-docs",           "Don't build documentation"
  option "without-gui",            "Do not build the experimental GUI"
  option "with-native-graphics",   "Use native OpenGL/FLTKgraphics (does not work with the GUI)"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "with-jit",               "Use the experimental JIT support (not recommended)"

  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-glpk",           "Do not use GLPK"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  depends_on :fortran

  depends_on "pkg-config"     => :build
  depends_on "gnu-sed"        => :build
  depends_on "texinfo"        => :build if build.with?("docs") && OS.linux?

  head do
    depends_on "bison"        => :build
    depends_on "automake"     => :build
    depends_on "autoconf"     => :build
    depends_on "qscintilla2"
    depends_on "qt"
    depends_on "fltk"
    depends_on "fontconfig"
    depends_on "freetype"
  end

  depends_on "pcre"
  if build.with? "gui"
    depends_on "qscintilla2"
    depends_on "qt"
  end
  if build.with? "native-graphics"
    depends_on "fltk"
    depends_on "fontconfig"
    depends_on "freetype"
  end
  depends_on "llvm"           if build.with? "jit"
  depends_on "curl"           if build.with?("curl") && MacOS.version == :leopard
  depends_on :java            => :recommended

  depends_on "gnuplot"       => [:recommended, build.with?("gui") ? "with-qt" : ""]
  depends_on "suite-sparse"   => :recommended
  depends_on "readline"       => :recommended
  depends_on "arpack"         => :recommended
  depends_on "fftw"           => :recommended
  depends_on "glpk"           => :recommended
  depends_on "gl2ps"          => :recommended
  depends_on "graphicsmagick" => :recommended  # imread/imwrite
  depends_on "hdf5"           => :recommended
  depends_on "qhull"          => :recommended
  depends_on "qrupdate"       => :recommended
  depends_on "epstool"        => :recommended

  depends_on "ghostscript"    => :recommended  # ps/pdf image output
  depends_on "pstoedit"       if build.with? "ghostscript"

  depends_on "openblas"       => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline" if build.with? "readline"
    args = ["--prefix=#{prefix}"]

    args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas" if build.with? "openblas"
    args << "--disable-docs"     if build.without? "docs"
    args << "--enable-jit"       if build.with? "jit"
    args << "--disable-gui"      if build.without? "gui"
    args << "--without-opengl"   if build.without?("native-graphics") && !build.head?

    args << "--disable-readline" if build.without? "readline"
    args << "--without-curl"     if build.without? "curl"
    args << "--without-fftw3"    if build.without? "fftw"
    args << "--without-glpk"     if build.without? "glpk"
    args << "--without-hdf5"     if build.without? "hdf5"
    args << "--disable-java"     if build.without? :java
    args << "--without-qhull"    if build.without? "qhull"
    args << "--without-qrupdate" if build.without? "qrupdate"

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
      sparse = Tab.for_name("suite-sparse")
      ENV.append_to_cflags "-L#{Formula["metis4"].opt_lib} -lmetis" if sparse.with? "metis4"
    end

    args << "--without-zlib"     if build.without? "zlib"
    args << "--with-x=no"        if OS.mac? # We don't need X11 for Mac at all

    system "./bootstrap" if build.head?

    # Libtool needs to see -framework to handle dependencies better.
    inreplace "configure", "-Wl,-framework -Wl,", "-framework "

    # The Mac build configuration passes all linker flags to mkoctfile to
    # be inserted into every oct/mex build. This is actually unnecessary and
    # can cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    if build.with?("gnuplot") && build.with?("gui")
      # ~/.octaverc takes precedence over site octaverc
      open("scripts/startup/local-rcfile", "a") do |file|
        file.write "setenv('GNUTERM','#{build.with?("gui") ? "qt" : ""}')"
      end
    end

    system "./configure", *args
    system "make", "all"
    system "make check 2>&1 | tee make-check.log" if build.with? "check"
    system "make", "install"
    prefix.install "make-check.log" if File.exist? "make-check.log"
    prefix.install "test/fntests.log" if File.exist? "test/fntests.log"
  end

  def caveats
    s = ""

    if build.with? "gnuplot"
      s += <<-EOS.undent

        gnuplot's Qt terminal is supported by default with the Octave GUI.
        Use other gnuplot graphics terminals by setting the environment variable
        GNUTERM in ~/.octaverc, and building gnuplot with the matching options.

          setenv('GNUTERM','qt')    # Default graphics terminal with Octave GUI
          setenv('GNUTERM','x11')   # Requires XQuartz; install gnuplot --with-x
          setenv('GNUTERM','wxt')   # wxWidgets/pango; install gnuplot --wx
          setenv('GNUTERM','aqua')  # Requires AquaTerm; install gnuplot --with-aquaterm

          You may also set this variable from within Octave.

      EOS
    end

    if build.with?("native graphics") || build.head?
      s += <<-EOS.undent

        You have configured Octave to use "native" OpenGL/FLTK plotting by
        default. If you prefer gnuplot, you can activate it for all future
        figures with the command
            graphics_toolkit ('gnuplot')
        or for a specific figure handle h using
            graphics_toolkit (h,'gnuplot')
      EOS
    end

    if build.head?
      s += <<-EOS.undent

        The HEAD installation activates the experimental GUI by default.
        To use the CLI version of octave, run the command "octave-cli".
      EOS
    elsif build.with? "gui"
      s += <<-EOS.undent

        The Octave GUI is experimental and not enabled by default. To use it,
        use the command-line argument "--force-gui"; e.g.,
            octave --force-gui
      EOS
      if build.with? "native-graphics"
        s += <<-EOS.undent

          Native graphics do *not* work with the GUI. You must switch to
          gnuplot when using it.
        EOS
      end
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
            arpack, qrupdate, suite-sparse, and octave. Please use the same BLAS
            settings for all (i.e., with the default, or "--with-openblas").
        EOS
      end
    end

    s += "\n" unless s.empty?
    s
  end

  test do
    system "octave", "--eval", "'(22/7 - pi)/pi'"
  end
end

__END__
diff --git a/libinterp/corefcn/comment-list.h b/libinterp/corefcn/comment-list.h
index 2f2c4d5..18df774 100644
--- a/libinterp/corefcn/comment-list.h
+++ b/libinterp/corefcn/comment-list.h
@@ -25,7 +25,7 @@ along with Octave; see the file COPYING.  If not, see
 
 #include <string>
 
-#include <base-list.h>
+#include "base-list.h"
 
 extern std::string get_comment_text (void);
 
diff --git a/libinterp/corefcn/oct.h b/libinterp/corefcn/oct.h
index c6d21ad..db06357 100644
--- a/libinterp/corefcn/oct.h
+++ b/libinterp/corefcn/oct.h
@@ -28,7 +28,7 @@ along with Octave; see the file COPYING.  If not, see
 // config.h needs to be first because it includes #defines that can */
 // affect other header files.
 
-#include <config.h>
+#include "config.h"
 
 #include "Matrix.h"
 
