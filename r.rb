class RDownloadStrategy < SubversionDownloadStrategy
  def stage
    cp_r File.join(cached_location, "."), Dir.pwd
  end
end

class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-3/R-3.4.1.tar.gz"
  sha256 "02b1135d15ea969a3582caeb95594a05e830a6debcdb5b85ed2d5836a6a3fc78"
  revision 1
  head "https://svn.r-project.org/R/trunk", :using => RDownloadStrategy

  # Do not remove executable permission from these scripts.
  # See https://github.com/Linuxbrew/linuxbrew/issues/614
  skip_clean "lib/R/bin" unless OS.mac?

  bottle do
    sha256 "2244a15ac903afe9e35ce3cf88388591b80e2811e03a95cc449251745f8e7d7c" => :sierra
    sha256 "876fea1ff71114bfc97833a51a7d0468476508ffc984845fa08fd6d5cceeb4f7" => :el_capitan
    sha256 "1ec175513db567fc5fb15a1390d530dce0a5c6f068e5d90670c6f84c67b3cfa3" => :yosemite
    sha256 "9c956b8854a9d964c35eb1840c6deff25c41fabf7139f1163d1db56a6c99c34b" => :x86_64_linux
  end

  option "without-accelerate", "Build without the Accelerate framework (use Rblas)"
  option "without-test", "Skip build-time tests (not recommended)"
  option "without-tcltk", "Build without Tcl/Tk"
  option "with-librmath-only", "Only build standalone libRmath library"

  deprecated_option "without-check" => "without-test"

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
  depends_on "curl" unless OS.mac?

  depends_on "openblas" => :optional
  depends_on "pango" => :optional
  depends_on "valgrind" => :optional
  depends_on :java => :optional
  depends_on :x11 => (OS.mac? ? :optional : :recommended)
  depends_on "cairo" => build.with?("x11") ? ["with-x11"] : []

  patch :DATA

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_have_decl_clock_gettime"] = "no"
    end

    # Fix cairo detection with Quartz-only cairo
    inreplace ["configure", "m4/cairo.m4"], "cairo-xlib.h", "cairo.h"

    args = [
      "--prefix=#{prefix}",
      "--with-cairo",
      "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
      "--enable-memory-profiling",
    ]

    # don't remember Homebrew's sed shim
    args << "SED=/usr/bin/sed" if File.exist?("/usr/bin/sed")

    if OS.linux?
      args << "--libdir=#{lib}" # avoid using lib64 on CentOS
      args << "--enable-R-shlib"
      # If LDFLAGS contains any -L options, configure sets LD_LIBRARY_PATH to
      # search those directories. Remove -LHOMEBREW_PREFIX/lib from LDFLAGS.
      ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"
    else
      args << "--enable-R-framework"

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
      ENV.O0
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

    # Help CRAN packages find gettext and readline
    %w[gettext readline].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

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

      # make Homebrew packages discoverable for R CMD INSTALL
      inreplace r_home/"etc/Makeconf" do |s|
        s.gsub! /^CPPFLAGS =.*/, "\\0 -I#{HOMEBREW_PREFIX}/include"
        s.gsub! /^LDFLAGS =.*/, "\\0 -L#{HOMEBREW_PREFIX}/lib"
        s.gsub! /.LDFLAGS =.*/, "\\0 $(LDFLAGS)"
      end

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

  def post_install
    return if build.with?("librmath-only")
    cellar_site_library = r_home/"site-library"
    site_library.mkpath
    cellar_site_library.unlink if cellar_site_library.exist? || cellar_site_library.symlink?
    ln_s site_library, cellar_site_library
  end

  def installed_short_version
    old_rhome = ENV.delete "R_HOME" # Rscript prints garbage if R_HOME is set
    `#{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
  ensure
    ENV["R_HOME"] = old_rhome
  end

  def r_home
    OS.mac? ? (prefix/"R.framework/Resources") : (prefix/"lib/R")
  end

  def site_library
    HOMEBREW_PREFIX/"lib/R/#{installed_short_version}/site-library"
  end

  def caveats
    if build.without? "librmath-only" then <<-EOS.undent
      To enable rJava support, run the following command:
        R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
      If you've installed a version of Java other than the default, you might need to instead use:
        R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I/Library/Java/JavaVirtualMachines/jdk<version>.jdk/"
      (where <version> can be found by running `java -version`, `/usr/libexec/java_home`, or `locate jni.h`), or:
        R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"
      EOS
    end
  end

  test do
    if build.without? "librmath-only"
      system bin/"Rscript", "-e", "print(1+1)"
      system bin/"Rscript", "-e", "quit('no', capabilities('cairo')[['cairo']] != TRUE)"
    end
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
