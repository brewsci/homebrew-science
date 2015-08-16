class RDownloadStrategy < SubversionDownloadStrategy
  def stage
    cp_r File.join(cached_location, "."), Dir.pwd
  end
end

class R < Formula
  homepage "http://www.r-project.org/"
  url "http://cran.rstudio.com/src/base/R-3/R-3.2.2.tar.gz"
  mirror "http://cran.r-project.org/src/base/R-3/R-3.2.2.tar.gz"
  sha256 "9c9152e74134b68b0f3a1c7083764adc1cb56fd8336bec003fd0ca550cd2461d"

  bottle do
    revision 1
    sha256 "56f2d6bdfa536e0b313e7a89bd61c25e074efc8425ed6ad7abe59e3389bf3958" => :yosemite
    sha256 "69f8c1a18d3077d0c7831de9dd63d1fcbf571d7b9dda9f5901500d0769f50186" => :mavericks
    sha256 "f7be5f555f2302c33f8763cd8063e37602cf37691fa5df5e489036566f84c2eb" => :mountain_lion
  end

  head do
    url "https://svn.r-project.org/R/trunk", :using => RDownloadStrategy
    depends_on :tex
  end

  option "without-accelerate", "Build without the Accelerate framework (use Rblas)"
  option "without-check", "Skip build-time tests (not recommended)"
  option "without-tcltk", "Build without Tcl/Tk"
  option "with-librmath-only", "Only build standalone libRmath library"

  depends_on "pkg-config" => :build
  depends_on "texinfo" => :build
  depends_on :fortran
  depends_on "readline"
  depends_on "gettext"
  depends_on "libtiff"
  depends_on "pcre"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "xz"

  depends_on "openblas" => :optional
  depends_on "valgrind" => :optional

  if OS.mac?
    depends_on "cairo"
    depends_on "pango" => :optional
    depends_on :x11 => :optional
  else
    depends_on "cairo" => :optional
    depends_on "pango" => :optional
    depends_on :x11 => :recommended
  end

  # This is the same script that Debian packages use.
  resource "completion" do
    url "https://rcompletion.googlecode.com/svn-history/r31/trunk/bash_completion/R", :using => :curl
    sha256 "2b5cac905ab5dd4889e8a356bbdf2dddff60f718a4104b169e48ca856716e705"
    version "r31"
  end

  patch :DATA

  def install
    # Fix cairo detection with Quartz-only cairo
    inreplace ["configure", "m4/cairo.m4"], "cairo-xlib.h", "cairo.h"

    args = [
      "--prefix=#{prefix}",
      "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
      "--enable-memory-profiling",
    ]

    if OS.linux?
      args << "--enable-R-shlib"
      # If LDFLAGS contains any -L options, configure sets LD_LIBRARY_PATH to
      # search those directories. Remove -LHOMEBREW_PREFIX/lib from LDFLAGS.
      ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    else
      args << "--enable-R-framework"
      args << "--with-cairo"

      # Disable building against the Aqua framework with CLT >= 6.0.
      # See https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63651
      # This should be revisited when new versions of GCC come along.
      if ENV.compiler != :clang && MacOS::CLT.version >= "6.0"
        args << "--without-aqua"
      else
        args << "--with-aqua"
      end
    end

    if build.with? "valgrind"
      args << "--with-valgrind-instrumentation=2"
      ENV.Og
    end

    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas" << "--with-lapack"
      ENV.append "LDFLAGS", "-L#{Formula["openblas"].opt_lib}"
    elsif build.with? "accelerate"
      args << "--with-blas=-framework Accelerate" << "--with-lapack"
      ENV.append_to_cflags "-D__ACCELERATE__" if ENV.compiler != :clang
      # Fall back to Rblas without-accelerate or -openblas
    end

    args << "--without-tcltk" if build.without? "tcltk"
    args << "--without-x" if build.without? "x11"

    # Also add gettext include so that libintl.h can be found when installing packages.
    ENV.append "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["gettext"].opt_lib}"

    # Sometimes the wrong readline is picked up.
    ENV.append "CPPFLAGS", "-I#{Formula["readline"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["readline"].opt_lib}"

    # Pull down recommended packages if building from HEAD.
    system "./tools/rsync-recommended" if build.head?

    system "./configure", *args

    if build.without? "librmath-only"
      system "make"
      ENV.deparallelize # Serialized installs, please
      system "make check 2>&1 | tee make-check.log" if build.with? "check"
      system "make", "install"

      # Link binaries, headers, libraries, & manpages from the Framework
      # into the normal locations
      if OS.mac?
        bin.install_symlink prefix/"R.framework/Resources/bin/R"
        bin.install_symlink prefix/"R.framework/Resources/bin/Rscript"
        frameworks.install_symlink prefix/"R.framework"
        include.install_symlink Dir[prefix/"R.framework/Resources/include/*"]
        lib.install_symlink prefix/"R.framework/Resources/lib/libR.dylib"
        man1.install_symlink prefix/"R.framework/Resources/man1/R.1"
        man1.install_symlink prefix/"R.framework/Resources/man1/Rscript.1"
      end

      # if this was built with a Homebrew gfortran, immunize to minor gcc version changes
      if (r_home/"etc/Makeconf").read.include? Formula["gcc"].prefix
        inreplace r_home/"etc/Makeconf", Formula["gcc"].prefix, Formula["gcc"].opt_prefix
      end

      bash_completion.install resource("completion")

      prefix.install "make-check.log" if build.with? "check"
    end

    cd "src/nmath/standalone" do
      system "make"
      ENV.deparallelize # Serialized installs, please
      system "make", "install"

      if OS.mac?
        lib.install_symlink Dir[prefix/"R.framework/Versions/[0-9]*/Resources/lib/libRmath.dylib"]
        include.install_symlink Dir[prefix/"R.framework/Versions/[0-9]*/Resources/include/Rmath.h"]
      end
    end
  end

  test do
    if build.without? "librmath-only"
      system bin/"Rscript", "-e", "print(1+1)"
      system bin/"Rscript", "-e", "quit('no', capabilities('cairo')[['cairo']] != TRUE)" if OS.mac?
    end
  end

  def caveats
    if build.without? "librmath-only" then <<-EOS.undent
      If you would like your installed R packages to survive minor R upgrades,
      you can run:
        mkdir -p ~/Library/R/#{xy}/library
      so R will preferentially install packages under your home directory
      instead of in the Cellar.

      To enable rJava support, run the following command:
        R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
      If you've installed a version of Java other than the default, you might need to instead use:
        R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I/Library/Java/JavaVirtualMachines/jdk<version>.jdk/"
      (where <version> can be found by running `java -version`, `/usr/libexec/java_home`, or `locate jni.h`), or:
        R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"
      EOS
    end
  end

  def xy
    stable.version.to_s.slice(/(\d.\d)/)
  end

  def r_home
    OS.mac? ? (prefix/"R.framework/Resources") : (prefix/"lib/R")
  end
end

__END__
diff --git a/src/modules/lapack/vecLibg95c.c b/src/modules/lapack/vecLibg95c.c
index ffc18e4..6728244 100644
--- a/src/modules/lapack/vecLibg95c.c
+++ b/src/modules/lapack/vecLibg95c.c
@@ -2,6 +2,12 @@
 #include <config.h>
 #endif

+#ifndef __has_extension
+#define __has_extension(x) 0
+#endif
+#define vImage_Utilities_h
+#define vImage_CVUtilities_h
+
 #include <AvailabilityMacros.h> /* for MAC_OS_X_VERSION_10_* -- present on 10.2+ (according to Apple) */
 /* Since OS X 10.8 vecLib requires Accelerate to be included first (which in turn includes vecLib) */
 #if defined MAC_OS_X_VERSION_10_8 && MAC_OS_X_VERSION_MIN_REQUIRED >= 1040
