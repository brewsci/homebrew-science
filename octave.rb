class Octave < Formula
  desc "high-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  url "http://ftpmirror.gnu.org/octave/octave-4.0.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/octave/octave-4.0.0.tar.gz"
  sha256 "4c7ee0957f5dd877e3feb9dfe07ad5f39b311f9373932f0d2a289dc97cca3280"
  revision 4

  stable do
    # Fix compilation of classdef with the clang compiler (bug #41178)
    # The bug is already fixed in the default branch, i.e., > 4.0
    # See: http://savannah.gnu.org/bugs/?41178
    patch do
      url "http://savannah.gnu.org/support/download.php?file_id=34691"
      sha256 "25a9c0b937b50de0acb4dc50e4d6d285ef54f1673e4b84530b53effe983bdd88"
    end
  end

  bottle do
    sha256 "789bf482df632b990dfa76f2195294acac5bd737e9e21e60f1a556b343f959f2" => :el_capitan
    sha256 "7ab5d93d324aa8ed0ee3f42b4548ae6258f19152a5d7f682c2381ff57a029ed3" => :yosemite
    sha256 "ef73c22b30cf0f21364196ff53e52850744bc2c9cf46e360e826756ecd05ec2b" => :mavericks
  end

  # Fix compilation of osmesa by exchangig the order of include
  # See: http://lists.nongnu.org/archive/html/octave-maintainers/2015-08/msg00001.html
  patch do
    url "https://savannah.gnu.org/patch/download.php?file_id=35085"
    sha256 "3a7f72f76329e0f40857587e06a1a9074da320423a85a6821b6fbc46bde6140d"
  end

  if OS.mac? && MacOS.clang_version < "7.0"
    # Fix the build error with LLVM 3.5svn (-3.6svn?) and libc++ (bug #43298)
    # See: http://savannah.gnu.org/bugs/?43298
    patch do
      url "http://savannah.gnu.org/bugs/download.php?file_id=32255"
      sha256 "ef83b32384a37cca13ecdd30d98dacac314b7c23f2c1df3d1113074bd1169c0f"
    end
    # Fixes includes "base-list.h" and "config.h" in comment-list.h and "oct.h" (bug #41027)
    # Core developers don't like this fix, see: http://savannah.gnu.org/bugs/?41027
    patch do
      url "http://savannah.gnu.org/bugs/download.php?file_id=31400"
      sha256 "efdf91390210a64e4732da15dcac576fb1fade7b85f9bacf4010d102c1974729"
    end
  end

  # dependencies needed for head
  # "librsvg" and ":tex" are currently not necessary
  # since we do not build the pdf docs ("DOC_TARGETS=")
  head do
    url "http://www.octave.org/hg/octave", :branch => "default", :using => :hg
    depends_on "autoconf"      => :build
    depends_on "automake"      => :build
    depends_on "bison"         => :build
    depends_on "fontconfig"
    depends_on "freetype"
  end

  skip_clean "share/info" # Keep the docs

  # options, enabled by default
  option "without-check",          "Do not perform build-time tests (not recommended)"
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-docs",           "Do not install documentation"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-glpk",           "Do not use GLPK"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-opengl",         "Do not use opengl"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  # options, disabled by default
  option "with-audio",             "Use the sndfile and portaudio libraries for audio operations"
  option "with-gui",               "Use the graphical user interface"
  option "with-java",              "Use Java, requires Java 6 from https://support.apple.com/kb/DL1572"
  option "with-jit",               "Use the experimental just-in-time compiler (not recommended)"
  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "with-osmesa",            "Use the OSmesa library (incompatible with opengl)"

  # build dependencies
  depends_on "gnu-sed"         => :build
  depends_on "pkg-config"      => :build

  # essential dependencies
  depends_on :fortran
  depends_on "texinfo"         => :build # we need >4.8
  depends_on "pcre"

  # recommended dependencies (implicit options)
  depends_on "readline"       => :recommended
  depends_on "arpack"         => :recommended
  depends_on "epstool"        => :recommended
  depends_on "ghostscript"    => :recommended  # ps/pdf image output
  depends_on "gl2ps"          => :recommended
  depends_on "graphicsmagick" => :recommended  # imread/imwrite

  # conditional dependecies (explicit options)
  depends_on "curl"            if build.with?("curl") && MacOS.version == :leopard
  depends_on "fftw"            if build.with? "fftw"
  depends_on "glpk"            if build.with? "glpk"
  depends_on "gnuplot"         if build.with? "gnuplot"
  depends_on "hdf5"            if build.with? "hdf5"
  depends_on :java => "1.6"    if build.with? "java"
  depends_on "llvm"            if build.with? "jit"
  depends_on "openblas"        if build.with? "openblas"
  depends_on "pstoedit"        if build.with? "ghostscript"
  depends_on "qhull"           if build.with? "qhull"
  depends_on "qrupdate"        if build.with? "qrupdate"
  depends_on "qscintilla2"     if build.with? "gui"
  depends_on "qt"              if build.with? "gui"
  depends_on "suite-sparse421" if build.with? "suite-sparse"
  depends_on :x11              if build.with? "osmesa"
  depends_on "libsndfile"      if build.with? "audio"
  depends_on "portaudio"       if build.with? "audio"

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline" if build.with? "readline"
    ENV.prepend_path "PATH", "#{Formula["texinfo"].opt_bin}" if build.head?

    # basic arguments
    args = ["--prefix=#{prefix}"]
    args << "--enable-dependency-tracking"
    args << "--enable-link-all-dependencies"
    args << "--enable-shared"
    args << "--disable-static"
    args << "--with-x=no" if OS.mac? # We don't need X11 for Mac at all

    # arguments for options enabled by default
    args << "--without-curl"             if build.without? "curl"
    args << "--disable-docs"             if build.without? "docs"
    args << "--without-fftw3"            if build.without? "fftw"
    args << "--without-glpk"             if build.without? "glpk"
    args << "--disable-gui"              if build.without? "gui"
    args << "--without-hdf5"             if build.without? "hdf5"
    args << "--without-opengl"           if build.without? "opengl"
    args << "--without-framework-opengl" if build.without? "opengl"
    args << "--without-OSMesa"           if build.without? "osmesa"
    args << "--without-qhull"            if build.without? "qhull"
    args << "--without-qrupdate"         if build.without? "qrupdate"
    args << "--disable-readline"         if build.without? "readline"
    args << "--without-zlib"             if build.without? "zlib"

    # arguments for options disabled by default
    args << "--with-portaudio"   if build.without? "audio"
    args << "--with-sndfile"     if build.without? "audio"
    args << "--disable-java"     if build.without? "java"
    args << "--enable-jit"       if build.with? "jit"
    args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas" if build.with? "openblas"

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

    # libtool needs to see -framework to handle dependencies better.
    inreplace "configure", "-Wl,-framework -Wl,", "-framework "

    # the Mac build configuration passes all linker flags to mkoctfile to
    # be inserted into every oct/mex build. This is actually unnecessary and
    # can cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    system "./configure", *args

    # call make with "DOC_TARGETS=" such that the manual is not build
    # due to broken osmesa which is required to generate the images
    # however the texinfo for built-in octave help is still generated
    # this can be disabled by "--without-docs"
    system "make", "all", "DOC_TARGETS="
    system "make check 2>&1 | tee make-check.log" if build.with? "check"
    system "make", "install", "DOC_TARGETS="

    prefix.install "make-check.log" if File.exist? "make-check.log"
    prefix.install "test/fntests.log" if File.exist? "test/fntests.log"
  end

  def caveats
    s = ""

    if build.with?("gui")
      s += <<-EOS.undent

      The graphical user interface is now used when running Octave interactively.
      The start-up option --no-gui will run the familiar command line interface.
      The option --no-gui-libs runs a minimalist command line interface that does not
      link with the Qt libraries and uses the fltk toolkit for plotting if available.

      EOS

    else

      s += <<-EOS.undent

      The graphical user interface is disabled by default since it is still buggy on
      OS X; use brew with the option --with-gui to enable it.

      EOS

    end

    if build.with?("gnuplot")
      s += <<-EOS.undent

        Octave was compiled with gnuplot; enable it via graphics_toolkit('gnuplot').
        All graphics terminals can be used by setting the environment variable GNUTERM
        in ~/.octaverc, and building gnuplot with the corresponding options.

          setenv('GNUTERM','qt')    # Requiers QT; install gnuplot --with-qt
          setenv('GNUTERM','x11')   # Requires XQuartz; install gnuplot --with-x11
          setenv('GNUTERM','wxt')   # Requires wxmac; install gnuplot --with-wxmac
          setenv('GNUTERM','aqua')  # Requires AquaTerm; install gnuplot --with-aquaterm

        You may also set this variable from within Octave. For printing the cairo backend
        is recommended, i.e., install gnuplot with --with-cairo, and use

          print -dpdfcairo figure.pdf

      EOS
    end

    if build.without?("osmesa") || (build.with?("osmesa") && build.with?("opengl"))
      s += <<-EOS.undent

      When using the the qt or fltk toolkits then invisible figures do not work because
      osmesa does currently not work with the Mac's OpenGL implementation. The usage of
      gnuplot is recommened.

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

  test do
    system "octave", "--eval", "(22/7 - pi)/pi"
  end
end
