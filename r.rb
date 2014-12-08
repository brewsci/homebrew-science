require 'formula'

class RDownloadStrategy < SubversionDownloadStrategy
  def stage
    quiet_safe_system 'cp', '-r', @clone, Dir.pwd
    Dir.chdir cache_filename
  end
end

class R < Formula
  homepage 'http://www.r-project.org/'
  url 'http://cran.rstudio.com/src/base/R-3/R-3.1.2.tar.gz'
  mirror 'http://cran.r-project.org/src/base/R-3/R-3.1.2.tar.gz'
  sha1 '93809368e5735a630611633ac1fa99010020c5d6'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "dd0561d83e304470274792dc8886d5ecd75c8f0a" => :yosemite
    sha1 "1a9a113e18d28bc0c3b0225a6df431e62489424a" => :mavericks
    sha1 "07ddfd37c259fdd769622d95d09f302ea0dc9ee5" => :mountain_lion
  end

  head do
    url 'https://svn.r-project.org/R/trunk', :using => RDownloadStrategy
    depends_on :tex
  end

  option "without-accelerate", "Build without the Accelerate framework (use Rblas)"
  option 'without-check', 'Skip build-time tests (not recommended)'
  option 'without-tcltk', 'Build without Tcl/Tk'
  option "with-librmath-only", "Only build standalone libRmath library"

  depends_on :fortran
  depends_on 'readline'
  depends_on 'gettext'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'cairo' if OS.mac?
  depends_on :x11 => :recommended
  depends_on 'valgrind' => :optional
  depends_on 'openblas' => :optional

  # This is the same script that Debian packages use.
  resource "completion" do
    url "https://rcompletion.googlecode.com/svn-history/r31/trunk/bash_completion/R", :using => :curl
    sha1 "ee39aa2de6319f41025cf8f618197d7efc16097c"
    version "r31"
  end

  def install
    # If LDFLAGS contains any -L options, configure sets LD_LIBRARY_PATH to
    # search those directories. Remove -LHOMEBREW_PREFIX/lib from LDFLAGS.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib" if OS.linux?

    args = [
      "--prefix=#{prefix}",
      "--with-libintl-prefix=#{Formula['gettext'].opt_prefix}",
    ]
    args += ["--with-aqua", "--enable-R-framework"] if OS.mac?

    if build.with? 'valgrind'
      args << '--with-valgrind-instrumentation=2'
      ENV.Og
    end

    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas" << "--with-lapack"
      ENV.append "LDFLAGS", "-L#{Formula["openblas"].opt_lib}"
    elsif build.with? "accelerate"
      args << "--with-blas=-framework Accelerate" << "--with-lapack"
      # Fall back to Rblas without-accelerate or -openblas
    end

    args << '--without-tcltk' if build.without? 'tcltk'
    args << '--without-x' if build.without? 'x11'

    # Also add gettext include so that libintl.h can be found when installing packages.
    ENV.append "CPPFLAGS", "-I#{Formula["gettext"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["gettext"].opt_lib}"

    # Sometimes the wrong readline is picked up.
    ENV.append "CPPFLAGS", "-I#{Formula['readline'].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula['readline'].opt_lib}"

    # Pull down recommended packages if building from HEAD.
    system './tools/rsync-recommended' if build.head?

    system "./configure", *args

    if build.without? "librmath-only"
      system "make"
      ENV.deparallelize # Serialized installs, please
      system "make check 2>&1 | tee make-check.log" if build.with? 'check'
      system "make install"

      # Link binaries, headers, libraries, & manpages from the Framework
      # into the normal locations
      if OS.mac?
        bin.install_symlink prefix/"R.framework/Resources/bin/R"
        bin.install_symlink prefix/"R.framework/Resources/bin/Rscript"
        frameworks.install_symlink prefix/"R.framework"
        include.install_symlink prefix/"R.framework/Resources/include/R.h"
        lib.install_symlink prefix/"R.framework/Resources/lib/libR.dylib"
        man1.install_symlink prefix/"R.framework/Resources/man1/R.1"
        man1.install_symlink prefix/"R.framework/Resources/man1/Rscript.1"
      end

      bash_completion.install resource('completion')

      prefix.install 'make-check.log' if build.with? 'check'
    end

    cd "src/nmath/standalone" do
      system "make"
      ENV.deparallelize # Serialized installs, please
      system "make", "install"

      if OS.mac?
        lib.install_symlink prefix/"R.framework/Versions/3.1/Resources/lib/libRmath.dylib"
        include.install_symlink prefix/"R.framework/Versions/3.1/Resources/include/Rmath.h"
      end
    end

  end

  test do
    (testpath / 'test.R').write('print(1+1);')
    system "r < test.R --no-save"
    system "rscript test.R"
  end if build.without? "librmath-only"

  def caveats; <<-EOS.undent
    To enable rJava support, run the following command:
      R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
    If you've installed a version of Java other than the default, you might need to instead use:
      R CMD javareconf JAVA_CPPFLAGS='-I/System/Library/Frameworks/JavaVM.framework/Headers -I/Library/Java/JavaVirtualMachines/jdk<version>.jdk/'
      (where <version> can be found by running `java -version` or `locate jni.h`)
    EOS
  end if build.without? "librmath-only"
end
