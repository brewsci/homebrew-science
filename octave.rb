class Octave < Formula
  desc "High-level interpreted language for numerical computing"
  homepage "https://www.gnu.org/software/octave/index.html"
  revision 3

  stable do
    url "https://ftp.gnu.org/gnu/octave/octave-4.2.1.tar.gz"
    mirror "https://ftpmirror.gnu.org/octave/octave-4.2.1.tar.gz"
    sha256 "80c28f6398576b50faca0e602defb9598d6f7308b0903724442c2a35a605333b"

    # Fix bug #49053: retina scaling of figures
    # see https://savannah.gnu.org/bugs/?49053
    resource "retina-scaling-patch" do
      url "https://savannah.gnu.org/support/download.php?file_id=38902"
      sha256 "d56eff94f9f811845ba3b0897b70cba43c0715a0102b1c79852b72ab10d24e6c"
    end

    resource "qscintilla2" do
      url "https://downloads.sourceforge.net/project/pyqt/QScintilla2/QScintilla-2.10/QScintilla_gpl-2.10.tar.gz"
      sha256 "16be30577bc178470936c458551f2512cc068aff6e7a7de6ed244e28c045f6ec"
    end
  end

  bottle do
    sha256 "46e8d33487b6d6b3d2caaca156bbf429665b4d57722e7363a765ceee20c89353" => :sierra
    sha256 "1dc116d75dd7dfefd20714facd654010e601305677a0f7b5705baee9461975d7" => :el_capitan
    sha256 "79082d37efe6e7b8077a753e2c84ca44af83095f61c0460943bef7ea3fa5aa20" => :yosemite
    sha256 "240bc743c180950eae429a8df113d7ca79162ec6229425c9071e694bfe8ae3fc" => :x86_64_linux
  end

  if OS.mac? && DevelopmentTools.clang_version < "7.0"
    # Fix the build error with LLVM 3.5svn (-3.6svn?) and libc++ (bug #43298)
    # See: http://savannah.gnu.org/bugs/?43298
    patch do
      url "http://savannah.gnu.org/bugs/download.php?file_id=32255"
      sha256 "ef83b32384a37cca13ecdd30d98dacac314b7c23f2c1df3d1113074bd1169c0f"
    end
  end

  # Fix bug #46723: retina scaling of buttons
  # see https://savannah.gnu.org/bugs/?46723
  patch :p1 do
    url "https://savannah.gnu.org/bugs/download.php?file_id=38206"
    sha256 "8307cec2b84fe546c8f490329b488ecf1da628ce823301b6765ffa7e6e292eed"
  end

  # dependencies needed for head
  head do
    url "http://www.octave.org/hg/octave", :branch => "default", :using => :hg
    depends_on :hg             => :build
    depends_on "autoconf"      => :build
    depends_on "automake"      => :build
    depends_on "icoutils"      => :build
    depends_on "librsvg"       => :build
  end

  # deprecated options
  deprecated_option "with-jit"      => "with-llvm"
  deprecated_option "with-audio"    => "with-sndfile"
  deprecated_option "without-check" => "without-test"

  unless OS.linux?
    deprecated_option "without-gui" => "without-qt@5.7"
    deprecated_option "without-qt5" => "without-qt@5.7"
  end

  # options, enabled by default
  option "without-curl",           "Do not use cURL (urlread/urlwrite/@ftp)"
  option "without-fftw",           "Do not use FFTW (fft,ifft,fft2,etc.)"
  option "without-fltk",           "Do not use FLTK graphics backend"
  option "without-glpk",           "Do not use GLPK"
  option "without-gnuplot",        "Do not use gnuplot graphics"
  option "without-hdf5",           "Do not use HDF5 (hdf5 data file support)"
  option "without-opengl",         "Do not use opengl"
  option "without-qhull",          "Do not use the Qhull library (delaunay,voronoi,etc.)"
  option "without-qrupdate",       "Do not use the QRupdate package (qrdelete,qrinsert,qrshift,qrupdate)"
  if OS.linux?
    option "with-qt@5.7",          "Compile with qt-based graphical user interface"
  else
    option "without-qt@5.7",       "Do not compile with qt-based graphical user interface"
  end

  option "without-qt@5.7",         "Do not compile with qt-based graphical user interface"
  option "without-sundials",       "Do not use SUNDIALS library"
  option "without-suite-sparse",   "Do not use SuiteSparse (sparse matrix operations)"
  option "without-test",           "Do not perform build-time tests (not recommended)"
  option "without-zlib",           "Do not use zlib (compressed MATLAB file formats)"

  # options, disabled by default
  option "with-java",              "Use Java, requires Java 6 from https://support.apple.com/kb/DL1572"
  option "with-llvm",              "Use the experimental just-in-time compiler (not recommended)"
  option "with-openblas",          "Use OpenBLAS instead of native LAPACK/BLAS"
  option "with-osmesa",            "Use the OSmesa library (incompatible with opengl)"
  option "with-portaudio",         "Use portaudio for audio playback and recording"
  option "with-sndfile",           "Use sndfile libraries for audio file operations"

  # build dependencies
  depends_on "gnu-sed"             => :build # http://lists.gnu.org/archive/html/octave-maintainers/2016-09/msg00193.html
  depends_on "pkg-config"          => :build

  # essential dependencies
  depends_on :fortran
  depends_on :x11
  depends_on "bison"               => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gawk"                => :build
  depends_on "texinfo"             => :build # we need >4.8
  depends_on "pcre"

  # recommended dependencies (implicit options)
  depends_on "arpack"              => :recommended
  depends_on "curl"                => :recommended
  depends_on "epstool"             => :recommended
  depends_on "fftw"                => :recommended
  depends_on "fltk"                => :recommended
  depends_on "gl2ps"               => :recommended
  depends_on "glpk"                => :recommended

  if OS.linux?
    depends_on "graphicsmagick"    => :optional # imread/imwrite
  else
    depends_on "graphicsmagick"    => :recommended # imread/imwrite
  end

  depends_on "hdf5"                => :recommended
  depends_on "qhull"               => :recommended
  depends_on "qrupdate"            => :recommended
  depends_on "readline"            => :recommended
  depends_on "suite-sparse"        => :recommended
  depends_on "transfig"            => :recommended

  # recommended blas dependencies
  depends_on "openblas"            => (OS.mac? ? :optional : :recommended)
  depends_on "veclibfort"          if build.without?("openblas") && OS.mac?

  # recommended ghostscript dependencies
  depends_on "ghostscript"         => :recommended # ps/pdf image output
  depends_on "pstoedit"            if build.with? "ghostscript"

  # recommended qt5 dependencies
  if OS.linux?
    depends_on "qt@5.7"            => :optional
  else
    depends_on "qt@5.7"            => :recommended
  end

  if build.with? "qt@5.7"
    depends_on "gnuplot" => [:recommended, "with-qt@5.7"]
  else
    depends_on "gnuplot" => :recommended
  end

  # other optional dependencies
  depends_on "libsndfile"          => :optional
  depends_on "llvm"                => :optional
  depends_on "portaudio"           => :optional
  depends_on :java                 => ["1.6+", :optional]

  # If GraphicsMagick was built from source, it is possible that it was
  # done to change quantum depth. If so, our Octave bottles are no good.
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
    ENV.prepend_path "PATH", Formula["texinfo"].bin
    ENV["FONTCONFIG_PATH"] = "/opt/X11/lib/X11/fontconfig"

    if build.stable?
      # Remove for > 4.2.1
      # Remove inline keyword on file_stat destructor which breaks macOS
      # compilation (bug #50234).
      # Upstream commit from 24 Feb 2017 http://hg.savannah.gnu.org/hgweb/octave/rev/a6e4157694ef
      inreplace "liboctave/system/file-stat.cc",
        "inline file_stat::~file_stat () { }", "file_stat::~file_stat () { }"

      resource("retina-scaling-patch").stage do
        inreplace "download.php" do |s|
          s.gsub! "#include <QApplication.h>", "#include <QApplication>"
          s.gsub! "__fontsize_points__", "fontsize_points" if build.stable?
        end
        system "patch", "-p1", "-i", Pathname.pwd/"download.php", "-d", buildpath
      end

      if build.with? "qt@5.7"
        libexec_qsci = libexec/"qscintilla2"
        libexec_qsci.mkpath
        resource("qscintilla2").stage do
          qsci_spec = ENV.compiler == :clang && MacOS.version >= :mavericks ? "macx-clang" : "macx-g++"
          qsci_args = %W[-config release -spec #{qsci_spec} PREFIX=#{libexec_qsci}]

          cd "Qt4Qt5" do
            inreplace "qscintilla.pro" do |s|
              s.gsub! "$$[QT_INSTALL_LIBS]", libexec_qsci/"lib"
              s.gsub! "$$[QT_INSTALL_HEADERS]", libexec_qsci/"include"
              s.gsub! "$$[QT_INSTALL_TRANSLATIONS]", libexec_qsci/"trans"
              s.gsub! "$$[QT_INSTALL_DATA]", libexec_qsci/"data"
              s.gsub! "$$[QT_HOST_DATA]", libexec_qsci/"data"
            end

            inreplace "features/qscintilla2.prf" do |s|
              s.gsub! "$$[QT_INSTALL_LIBS]", libexec_qsci/"lib"
              s.gsub! "$$[QT_INSTALL_HEADERS]", libexec_qsci/"include"
            end

            system "#{Formula["qt@5.7"].opt_bin}/qmake", "qscintilla.pro", *qsci_args
            system "make"
            system "make", "install"
          end
          libexec_qsci.install "Changelog", "LICENSE", "NEWS", "README"
        end
        # fix up lib ID, which has no path
        MachO::Tools.change_dylib_id("#{libexec_qsci}/lib/libqscintilla2_qt5.dylib",
                                     "#{opt_libexec}/qscintilla2/lib/libqscintilla2_qt5.dylib")
      end
    end

    # basic arguments
    args = ["--prefix=#{prefix}"]
    args << "--enable-dependency-tracking"
    args << "--enable-link-all-dependencies"
    args << "--enable-shared"
    args << "--disable-static"
    args << "--disable-docs"
    args << "--with-x=no" if OS.mac? # We don't need X11 for Mac at all

    # arguments for options enabled by default
    args << "--without-curl"             if build.without? "curl"
    args << "--without-fftw3"            if build.without? "fftw"
    args << "--with-fltk-prefix=#{Formula["fltk"].opt_prefix}" if build.with? "fltk"
    args << "--without-glpk"             if build.without? "glpk"
    args << "--without-qt"               if build.without? "qt@5.7"
    args << "--without-opengl"           if build.without? "opengl"
    args << "--without-framework-opengl" if build.without? "opengl"
    args << "--without-OSMesa"           if build.without? "osmesa"
    args << "--without-qhull"            if build.without? "qhull"
    args << "--without-qrupdate"         if build.without? "qrupdate"
    args << "--disable-readline"         if build.without? "readline"
    args << "--without-zlib"             if build.without? "zlib"

    # arguments for options disabled by default
    args << "--with-portaudio"           if build.with? "portaudio"
    args << "--with-sndfile"             if build.with? "sndfile"
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
      ENV.append "LDFLAGS", "-L#{Formula["suite-sparse"].opt_lib} -lsuitesparseconfig"
      ENV.append "LDFLAGS", "-L#{Formula["metis"].opt_lib} -lmetis"
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
        args << "--with-blas=-L#{Formula["veclibfort"].opt_lib} -lvecLibFort"
      end
    else # OS.linux? and without "openblas"
      args << "--with-blas=-lblas -llapack"
    end

    if build.head?
      args << "--disable-64"
      system "./bootstrap"
    end

    # the Mac build configuration passes all linker flags to mkoctfile to
    # be inserted into every oct/mex build. This is actually unnecessary and
    # can cause linking problems.
    inreplace "src/mkoctfile.in.cc", /%OCTAVE_CONF_OCT(AVE)?_LINK_(DEPS|OPTS)%/, '""'

    if build.with? "qt@5.7"
      # Octave does strict assumptions on the name of qscintilla2
      # see http://savannah.gnu.org/bugs/?48773
      # Also, add support for QScintilla2 2.10's libqscintilla2_qt5
      inreplace "configure", "qscintilla2-qt5 qt5scintilla2", "qscintilla2_qt5 qscintilla2-qt5 qt5scintilla2 qscintilla2"

      # Add vendored prefix to flags
      libexec_qsci = libexec/"qscintilla2"
      ENV.append "CPPFLAGS", "-I#{libexec_qsci}/include"
      ENV.append "LDFLAGS", "-L#{libexec_qsci}/lib"
    end

    system "./configure", *args
    system "make", "all"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test/fntests.log" if File.exist? "test/fntests.log"
  end

  def caveats
    s = ""

    if build.with?("qt@5.7")
      s += <<-EOS.undent

      Octave is compiled with a graphical user interface. The start-up option --no-gui
      will run the familiar command line interface. The option --no-gui-libs runs a
      minimalistic command line interface that does not link with the Qt libraries and
      uses the fltk toolkit for plotting if available.

      EOS

    else

      s += <<-EOS.undent

      Octave's graphical user interface is disabled; compile Octave with the option
      --with-qt@5.7 to enable it.

      EOS

    end

    if build.with?("gnuplot") || build.with?("fltk")
      s += <<-EOS.undent

        Several graphics toolkit are available. You can select them by using the command
        'graphics_toolkit' in Octave.  Individual Gnuplot terminals can be chosen by setting
        the environment variable GNUTERM and building gnuplot with the following options:

          setenv('GNUTERM','qt')    # Requires QT; install gnuplot --with-qt5
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

      When using the native Qt or fltk toolkits then invisible figures do not work because
      osmesa is incompatible with Mac's OpenGL. The usage of gnuplot is recommended.

      EOS
    end

    s += "\n" unless s.empty?
    s
  end

  test do
    system bin/"octave", "--eval", "(22/7 - pi)/pi"
    # this is supposed to crash octave if there is a problem with veclibfort
    system bin/"octave", "--eval", "single ([1+i 2+i 3+i]) * single ([ 4+i ; 5+i ; 6+i])"
  end
end
