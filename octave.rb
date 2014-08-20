require "formula"

class Octave < Formula
  homepage "http://www.gnu.org/software/octave/index.html"
  url      "http://ftpmirror.gnu.org/octave/octave-3.8.1.tar.bz2"
  mirror   "http://ftp.gnu.org/gnu/octave/octave-3.8.1.tar.bz2"
  sha1     "2951aeafe58d562672feb80dd8c3cfe0643a5087"
  head     "http://www.octave.org/hg/octave", :branch => "gui-release", :using => :hg

  stable do
    # Allows the arrow keys to page through command history.
    # See: https://savannah.gnu.org/bugs/?41337
    patch do
      url "https://savannah.gnu.org/bugs/download.php?file_id=30734"
      sha1 "e8fb39b7ca1525d67e6d24f3c189b441b60fcdab"
    end
  end

  # Allows mkoctfile to process "-framework vecLib" properly.
  # See: https://savannah.gnu.org/bugs/?42002
  patch do
    url "https://savannah.gnu.org/patch/download.php?file_id=31072"
    sha1 "19f2dcaf636f1968c4b1639797415f83fb21d5a3"
  end

  skip_clean "share/info" # Keep the docs

  option "without-check",          "Skip build-time tests (not recommended)"
  option "without-docs",           "Do not build documentation"
  option "without-gui",            "Do not build the experimental GUI"
  option "with-native-graphics",   "Use native OpenGL/FLTKgraphics (does not work with the GUI)"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "with-jit",               "Use the experimental JIT support (not recommended)"

  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-glpk",           "Do not use GLPK"
  option "without-ghostscript",    "Do not use Ghostscript (PS/PDF image output)"
  option "without-graphicsmagick", "Do not use GraphicsMagick++ (imread,imwrite)"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  depends_on :fortran

  depends_on "pkg-config"     => :build
  depends_on "gnu-sed"        => :build
  if build.with? "docs"
    depends_on "texinfo"      => :build
    depends_on :tex           => :build
  end

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
  depends_on "curl"           if build.with? "curl" and MacOS.version == :leopard

  depends_on "gnuplot"        => :recommended
  depends_on "suite-sparse"   => :recommended
  depends_on "readline"       => :recommended
  depends_on "arpack"         => :recommended
  depends_on "fftw"           => :recommended
  depends_on "glpk"           => :recommended
  depends_on "gl2ps"          => :recommended
  depends_on "graphicsmagick" => :recommended
  depends_on "ghostscript"    => :recommended
  depends_on "hdf5"           => :recommended
  depends_on "qhull"          => :recommended
  depends_on "qrupdate"       => :recommended
  depends_on "pstoedit"       => :recommended
  depends_on "epstool"        => :recommended

  depends_on "openblas"       => :optional

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV["JAVA_HOME"] = `/usr/libexec/java_home`.chomp!

    args = [ "--prefix=#{prefix}" ]

    args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas" if build.with? "openblas"
    args << "--disable-docs"     if build.without? "docs"
    args << "--enable-jit"       if build.with?    "jit"
    args << "--disable-gui"      if build.without? "gui"
    args << "--without-opengl"   if build.without? "native-graphics" and not build.head?

    args << "--disable-readline" if build.without? "readline"
    args << "--without-curl"     if build.without? "curl"
    args << "--without-fftw3"    if build.without? "fftw"
    args << "--without-glpk"     if build.without? "glpk"
    args << "--without-hdf5"     if build.without? "hdf5"
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
    args << "--with-x=no"     #We don't need X11 for Mac at all

    system "./bootstrap" if build.head?

    # Libtool needs to see -framework to handle dependencies better.
    inreplace "configure", "-Wl,-framework -Wl,", "-framework "

    # The Mac build configuration passes all linker flags to mkoctfile to
    # be inserted into every oct/mex build. This is actually unnecessary and
    # can cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    system "./configure", *args
    system "make all"
    system "make check 2>&1 | tee make-check.log" if build.with? "check"
    system "make install"
    prefix.install "make-check.log" if File.exist? "make-check.log"
    prefix.install "test/fntests.log" if File.exist? "test/fntests.log"
  end

  def caveats
    s = ""

    if build.with? "gnuplot"
      s = s + <<-EOS.undent

        To use the gnuplot plotting engine, you must set the environment
        variable GNUTERM. Valid choices include:
            GNUTERM=x11   # X windows must be installed
            GNUTERM=qt    # gnuplot must have been compiled with Qt support
            GNUTERM=aqua  # if you are using Aquaterm
        You may also set this variable from within Octave with the command
            setenv('GNUTERM','qt') % or 'x11', or 'aqua'
      EOS
    end

    if build.with? "native graphics" or build.head?
      s = s + <<-EOS.undent

        You have configured Octave to use "native" OpenGL/FLTK plotting by
        default. If you prefer gnuplot, you can activate it for all future
        figures with the command
            graphics_toolkit ('gnuplot')
        or for a specific figure handle h using
            graphics_toolkit (h,'gnuplot')
      EOS
    end

    if build.head?
      s = s + <<-EOS.undent

        The HEAD installation activates the experimental GUI by default.
        To use the CLI version of octave, run the command "octave-cli".
      EOS
    elsif build.with? "gui"
      s = s + <<-EOS.undent

        The Octave GUI is experimental and not enabled by default. To use it,
        use the command-line argument "--force-gui"; e.g.,
            octave --force-gui
      EOS
      if build.with? "native-graphics"
        s = s + <<-EOS.undent

          Native graphics do *not* work with the GUI. You must switch to
          gnuplot when using it.
        EOS
      end
    end

    logfile = "#{prefix}/make-check.log"
    if File.exist? logfile
      logs = `grep 'libinterp/array/.*FAIL \\d' #{logfile}`
      unless logs.empty?
        s = s + <<-EOS.undent

            Octave's self-tests for this installation produced the following failues:
            --------
        EOS
        s = s + logs + <<-EOS.undent
            --------
            These failures indicate a conflict between Octave and its BLAS-related
            dependencies. You can likely correct these by removing and reinstalling
            arpack, qrupdate, suite-sparse, and octave. Please use the same BLAS
            settings for all (i.e., with the default, or "--with-openblas").
        EOS
        end
    end

    s = s + "\n" unless s.empty?
    s
  end
end
