require 'formula'

class Octave < Formula
  homepage 'http://www.gnu.org/software/octave/index.html'
  url 'http://ftpmirror.gnu.org/octave/octave-3.8.0.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/octave/octave-3.8.0.tar.bz2'
  sha1 'ebb03485b72d97fa01f105460f81016f94680f77'

  skip_clean 'share/info' # Keep the docs

  option 'without-check', 'Skip build-time tests (not recommended)'
  option 'without-docs', 'Do not build documentation'

  depends_on :fortran

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build
  depends_on 'texinfo' => :build     # OS X's makeinfo won't work for this

  depends_on :x11
  depends_on 'fftw'
  # When building 64-bit binaries on Snow Leopard, there are naming issues with
  # the dot product functions in the BLAS library provided by Apple's
  # Accelerate framework. See the following thread for the gory details:
  #
  #   http://www.macresearch.org/lapackblas-fortran-106
  #
  # We can work around the issues using dotwrp.
  depends_on 'dotwrp' if MacOS.version == :snow_leopard and MacOS.prefer_64_bit?
  # octave refuses to work with BSD readline, so it's either this or --disable-readline
  depends_on 'readline'
  depends_on 'curl' if MacOS.version == :leopard # Leopard's libcurl is too old

  depends_on 'arpack'
  depends_on 'suite-sparse'
  depends_on 'hdf5'
  depends_on 'pcre'
  depends_on 'qhull'
  depends_on 'qrupdate'

  depends_on 'openblas' => :optional
  depends_on 'graphicsmagick' => :recommended
  depends_on 'gnuplot' => :recommended
  depends_on 'fltk' => :optional
  depends_on 'qt' => :optional

  # The fix for std::unordered_map requires regenerating
  # configure. Remove once the fix is in next release.
  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on :libtool => :build

  def blas_flags
    flags = []
    if build.with? 'openblas'
      flags << "-L#{Formula["openblas"].lib} -lopenblas"
    else
      flags << "-ldotwrp" if MacOS.version == :snow_leopard and MacOS.prefer_64_bit?
      # Cant use `-framework Accelerate` because `mkoctfile`, the tool used to
      # compile extension packages, can't parse `-framework` flags.
      flags << "-Wl,-framework,Accelerate"
    end
    flags.join(" ")
  end

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"

    args = [
      '--disable-dependency-tracking',
      "--prefix=#{prefix}",
      "--with-blas=#{blas_flags}",
      "--with-lapack=#{blas_flags}",
      # SuiteSparse-4.x.x fix, see http://savannah.gnu.org/bugs/?37031
      '--with-umfpack=-lumfpack -lsuitesparseconfig',
      '--disable-jit'
    ]
    args << '--without-framework-carbon' if MacOS.version >= :lion
    # avoid spurious 'invalid assignment to cs-list' erorrs on 32 bit installs:
    args << 'CXXFLAGS=-O0' unless MacOS.prefer_64_bit?
    args << '--disable-docs' if build.without? 'docs'
    args << '--without-opengl' if build.without? 'fltk'
    args << '--disable-gui' if build.without? 'qt'

    # The fix for std::unordered_map requires regenerating
    # configure. Remove once the fix is in next release.
    system "autoreconf", "-ivf"

    system "./configure", *args
    system "make all"
    system "make check 2>&1 | tee make-check.log" if build.with? 'check'
    system "make install"

    prefix.install ["test/fntests.log", "make-check.log"] if build.with? 'check'
  end

  def caveats
    native_caveats = <<-EOS.undent
      Octave supports "native" plotting using OpenGL and FLTK. You can activate
      it for all future figures using the Octave command

          graphics_toolkit ("fltk")

      or for a specific figure handle h using

          graphics_toolkit (h, "fltk")

      Otherwise, gnuplot is still used by default, if available.
    EOS

    gnuplot_caveats = <<-EOS.undent
      When plotting with gnuplot, you should set "GNUTERM=x11" before running octave;
      if you are using Aquaterm, use "GNUTERM=aqua".
    EOS

    glpk_caveats = <<-EOS.undent

      GLPK functionality has been disabled due to API incompatibility.
    EOS

    s = glpk_caveats
    s = gnuplot_caveats + s if build.with? 'gnuplot'
    s = native_caveats + s if build.with? 'fltk'
  end
end
