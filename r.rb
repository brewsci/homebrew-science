require 'formula'

class RDownloadStrategy < SubversionDownloadStrategy
  def stage
    quiet_safe_system 'cp', '-r', @clone, Dir.pwd
    Dir.chdir cache_filename
  end
end

class R < Formula
  homepage 'http://www.r-project.org/'
  url 'http://cran.rstudio.com/src/base/R-3/R-3.1.1.tar.gz'
  mirror 'http://cran.r-project.org/src/base/R-3/R-3.1.1.tar.gz'
  sha1 'e974ecc92e49266529e8e791e02a80c75e50b696'

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
  resource 'completion' do
    url 'https://rcompletion.googlecode.com/svn-history/r28/trunk/bash_completion/R', :using => :curl
    version 'r28'
    sha1 'af734b8624b33f2245bf88d6782bea0dc5d829a4'
  end

  def install
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

      # Link binaries and manpages from the Framework
      # into the normal locations
      bin.mkpath
      man1.mkpath

      if OS.mac?
        ln_s prefix+"R.framework/Resources/bin/R", bin
        ln_s prefix+"R.framework/Resources/bin/Rscript", bin
        ln_s prefix+"R.framework/Resources/man1/R.1", man1
        ln_s prefix+"R.framework/Resources/man1/Rscript.1", man1
      end

      bash_completion.install resource('completion')

      prefix.install 'make-check.log' if build.with? 'check'
    end

    cd "src/nmath/standalone" do
      system "make"
      include.mkpath
      ENV.deparallelize # Serialized installs, please
      system "make", "install"

      if OS.mac?
        lib.mkpath
        ln_s prefix+"R.framework/Versions/3.1/Resources/lib/libRmath.dylib", lib
        ln_s prefix+"R.framework/Versions/3.1/Resources/include/Rmath.h", include
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
    EOS
  end if build.without? "librmath-only"
end
