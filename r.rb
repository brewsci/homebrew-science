require 'formula'

class R < Formula
  homepage 'http://www.r-project.org/'
  url 'http://cran.rstudio.com/src/base/R-3/R-3.1.0.tar.gz'
  mirror 'http://cran.r-project.org/src/base/R-3/R-3.1.0.tar.gz'
  sha1 'a9d13932c739cc12667c6a17fabd9361624a1708'

  head 'https://svn.r-project.org/R/trunk'

  option 'without-check', 'Skip build-time tests (not recommended)'
  option 'without-tcltk', 'Build without Tcl/Tk'

  depends_on :fortran
  depends_on 'readline'
  depends_on 'gettext'
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'cairo'
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
      "--with-aqua",
      "--with-libintl-prefix=#{Formula['gettext'].prefix}",
      "--enable-R-framework",
    ]

    if build.with? 'valgrind'
      args << '--with-valgrind-instrumentation=2'
      ENV.Og
    end

    args << '--with-lapack' + ((build.with? 'openblas') ? '=-lopenblas' : '')
    args << '--with-blas=-lopenblas' if build.with? 'openblas'
    args << '--without-tcltk' if build.without? 'tcltk'
    args << '--without-x' if build.without? 'x11'

    # Also add gettext include so that libintl.h can be found when installing packages.
    ENV.append "CPPFLAGS", "-I#{Formula['gettext'].include}"

    # Pull down recommended packages if building from HEAD.
    system './tools/rsync-recommended' if build.head?

    system "./configure", *args
    system "make"
    ENV.deparallelize # Serialized installs, please
    system "make check 2>&1 | tee make-check.log" if build.with? 'check'
    system "make install"

    # Link binaries and manpages from the Framework
    # into the normal locations
    bin.mkpath
    man1.mkpath

    ln_s prefix+"R.framework/Resources/bin/R", bin
    ln_s prefix+"R.framework/Resources/bin/Rscript", bin
    ln_s prefix+"R.framework/Resources/man1/R.1", man1
    ln_s prefix+"R.framework/Resources/man1/Rscript.1", man1

    bash_completion.install resource('completion')

    prefix.install 'make-check.log' if build.with? 'check'
  end

  def caveats; <<-EOS.undent
    To enable rJava support, run the following command:
      R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
    EOS
  end
end
