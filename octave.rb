class Octave < Formula
  desc "high-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"

  stable do
    url "https://ftpmirror.gnu.org/octave/octave-4.0.3.tar.gz"
    sha256 "5a16a42fca637ae1b55b4a5a6e7b16a6df590cbaeeb4881a19c7837789515ec6"

    # Fix alignment of dock widget titles for OSX (bug #46592)
    # See: http://savannah.gnu.org/bugs/?46592
    patch do
      url "http://hg.savannah.gnu.org/hgweb/octave/raw-rev/e870a68742a6"
      sha256 "0ddcd8dd032be79d5a846ad2bc190569794e4e1a33ce99f25147d70ae6974682"
    end

    # Fix bug #48407: libinterp fails to link to libz
    patch :p0 do
      url "http://savannah.gnu.org/bugs/download.php?file_id=37717"
      sha256 "feeaad0d00be3008caef2162b549c42fd937f3fb02a36d01cde790a589d4eb2d"
    end
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
    depends_on :hg             => :build
    depends_on "autoconf"      => :build
    depends_on "automake"      => :build
    depends_on "bison"         => :build
    depends_on "icoutils"      => :build
  end

  bottle do
    sha256 "ab2cd4059874f137f57cd956a19cd7bc434a748a33404fe844da1d4f7f484967" => :el_capitan
    sha256 "ee6252781080ac5e9f63cad5ed1fe013e36eb6b3cc80efa45ec68ab52f3287db" => :yosemite
    sha256 "8556db1fe1b44dfa0169c086c3497906df7c0200329a8f160eca818bd4f35c8d" => :mavericks
  end

  skip_clean "share/info" # Keep the docs

  # deprecated options
  deprecated_option "without-check" => "without-test"

  # options, enabled by default
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-docs",           "Do not install documentation"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-fltk",           "Do not use FLTK graphics backend"
  option "without-glpk",           "Do not use GLPK"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "without-gui",            "Do not use the graphical user interface"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-opengl",         "Do not use opengl"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-test",           "Do not perform build-time tests (not recommended)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  # options, disabled by default
  option "with-audio",             "Use the sndfile and portaudio libraries for audio operations"
  option "with-java",              "Use Java, requires Java 6 from https://support.apple.com/kb/DL1572"
  option "with-jit",               "Use the experimental just-in-time compiler (not recommended)"
  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "with-osmesa",            "Use the OSmesa library (incompatible with opengl)"

  # build dependencies
  depends_on "gnu-sed"         => :build
  depends_on "pkg-config"      => :build

  # essential dependencies
  depends_on :fortran
  depends_on :x11
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "texinfo"         => :build # we need >4.8
  depends_on "pcre"

  # recommended dependencies (implicit options)
  depends_on "readline"       => :recommended
  depends_on "arpack"         => :recommended
  depends_on "epstool"        => :recommended
  depends_on "ghostscript"    => :recommended  # ps/pdf image output
  depends_on "gl2ps"          => :recommended
  depends_on "graphicsmagick" => :recommended  # imread/imwrite
  depends_on "transfig"       => :recommended

  # conditional dependecies (explicit options)
  depends_on "curl"            if build.with?("curl") && MacOS.version == :leopard
  depends_on "fftw"            if build.with? "fftw"
  depends_on "fltk"            if build.with? "fltk"
  depends_on "glpk"            if build.with? "glpk"
  depends_on "gnuplot"         if build.with? "gnuplot"
  depends_on "hdf5"            if build.with? "hdf5"
  depends_on :java => "1.6+"   if build.with? "java"
  depends_on "llvm"            if build.with? "jit"
  depends_on "pstoedit"        if build.with? "ghostscript"
  depends_on "qhull"           if build.with? "qhull"
  depends_on "qrupdate"        if build.with? "qrupdate"
  depends_on "qscintilla2"     if build.with? "gui"
  depends_on "qt"              if build.with? "gui"
  depends_on "suite-sparse"    if build.with? "suite-sparse"
  depends_on "libsndfile"      if build.with? "audio"
  depends_on "portaudio"       if build.with? "audio"
  depends_on "veclibfort"      if build.without? "openblas"

  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  # If GraphicsMagick was built from source, it is possible that it was
  # done to change quantum depth.  If so, our Octave bottles are no good.
  # https://github.com/Homebrew/homebrew-science/issues/2737
  if build.with? "graphicsmagick"
    def pour_bottle?
      Tab.for_name("graphicsmagick").bottle?
    end
  end

  def install
    ENV.m64 if MacOS.prefer_64_bit?
    ENV.append_to_cflags "-D_REENTRANT"
    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib} -lreadline" if build.with? "readline"
    ENV.prepend_path "PATH", "#{Formula["texinfo"].opt_bin}"
    ENV["FONTCONFIG_PATH"] = "/opt/X11/lib/X11/fontconfig"

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
    args << "--with-fltk-prefix=#{Formula["fltk"].opt_prefix}" if build.with? "fltk"
    args << "--without-glpk"             if build.without? "glpk"
    args << "--disable-gui"              if build.without? "gui"
    args << "--without-opengl"           if build.without? "opengl"
    args << "--without-framework-opengl" if build.without? "opengl"
    args << "--without-OSMesa"           if build.without? "osmesa"
    args << "--without-qhull"            if build.without? "qhull"
    args << "--without-qrupdate"         if build.without? "qrupdate"
    args << "--disable-readline"         if build.without? "readline"
    args << "--without-zlib"             if build.without? "zlib"

    # arguments for options disabled by default
    args << "--with-portaudio"           if build.without? "audio"
    args << "--with-sndfile"             if build.without? "audio"
    args << "--disable-java"             if build.without? "java"
    args << "--enable-jit"               if build.with? "jit"

    # ensure that the right hdf5 library is used
    if build.with? "hdf5"
      args << "--with-hdf5-includedir=#{Formula["hdf5"].opt_include}"
      args << "--with-hdf5-libdir=#{Formula["hdf5"].opt_lib}"
    else
      args << "--without-hdf5"
    end

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
      ENV.append_to_cflags "-L#{Formula["suite-sparse"].opt_lib} -lsuitesparseconfig"
      ENV.append_to_cflags "-L#{Formula["metis"].opt_lib} -lmetis"
    end

    # check if openblas settings are compatible
    if build.with? "openblas"
      if ["arpack", "qrupdate", "suite-sparse"].any? { |n| Tab.for_name(n).without? "openblas" }
        odie "Octave is compiled --with-openblas but arpack, qrupdate or suite-sparse are not."
      else
        args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
      end
    elsif OS.mac? # without "openblas"
      if ["arpack", "qrupdate", "suite-sparse"].any? { |n| Tab.for_name(n).with? "openblas" }
        odie "Arpack, qrupdate or suite-sparse are compiled --with-openblas but Octave is not."
      else
        args << "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lveclibFort"
      end
    else # OS.linux? and without "openblas"
      args << "-lblas -llapack"
    end

    system "./bootstrap" if build.head?

    # libtool needs to see -framework to handle dependencies better.
    inreplace "configure", "-Wl,-framework -Wl,", "-framework "

    # the Mac build configuration passes all linker flags to mkoctfile to
    # be inserted into every oct/mex build. This is actually unnecessary and
    # can cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    # make gnuplot the default backend since the native qt backend is rather unstable
    # if (build.with? "gnuplot") && (Tab.for_name("gnuplot").with? "qt")
    #   system "echo", "\"graphics_toolkit('gnuplot');\" >> \"scripts/startup/local-rcfile\""
    #   system "echo", "\"setenv('GNUTERM','qt');\" >> \"scripts/startup/local-rcfile\"" if Tab.for_name("gnuplot").with? "qt"
    # end

    system "./configure", *args

    # call make with "DOC_TARGETS=" such that the manual is not build
    # due to broken osmesa which is required to generate the images
    # however the texinfo for built-in octave help is still generated
    # this can be disabled by "--without-docs"
    system "make", "all", "DOC_TARGETS="
    system "make", "check", "DOC_TARGETS=" if build.with? "test"
    system "make", "install", "DOC_TARGETS="

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

      The graphical user interface is now enabled by default; run 'octave-cli' or
      install via brew with the option --without-gui to disable it.

      EOS

    end

    if build.with?("gnuplot")
      s += <<-EOS.undent

        Gnuplot is configured as default graphics toolkit, this can be changed within
        Octave using 'graphics_toolkit'. Other Gnuplot terminals can be used by setting
        the environment variable GNUTERM and building gnuplot with the following options.

          setenv('GNUTERM','qt')    # Requires QT; install gnuplot --with-qt
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

      When using the native qt or fltk toolkits then invisible figures do not work because
      osmesa does currently not work with the Mac's OpenGL implementation. The usage of
      gnuplot is recommended.

      EOS
    end

    if build.without?("openblas")
      s += <<-EOS.undent

      Octave has been compiled with Apple's BLAS routines, this leads to segfaults in some
      tests. The option "--with-openblas" is a more conservative choice.

      EOS
    end

    s += "\n" unless s.empty?
    s
  end

  test do
    system "octave", "--eval", "(22/7 - pi)/pi"
    # this is supposed to crash octave if there is a problem with veclibfort
    system "octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
  end
end
