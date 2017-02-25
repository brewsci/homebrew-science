class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "http://www.dynare.org"
  revision 6

  stable do
    url "https://www.dynare.org/release/source/dynare-4.4.3.tar.xz"
    sha256 "d00f97f72bcad7486ec1d18640d44b607d91ff9f585c9b4e01d08b6a3deeae21"

    depends_on "matlab2tikz"
  end

  bottle do
    sha256 "fcac75f9d214ea1929f6450819c54a9fa3de443f7c877b6b0d04e78be3af93d9" => :sierra
    sha256 "c50849dc867abd06aeebcf74a32e757320f02594ced3270ef3f039d362eb3726" => :el_capitan
    sha256 "f92bf9e37b156795c3b2fa818331ddbb576c5373211ac1da2712a925f6829292" => :yosemite
  end

  head do
    url "https://github.com/DynareTeam/dynare.git"

    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  option "with-matlab=", "Path to Matlab root directory (to build mex files)"
  option "with-matlab-version=", "Matlab version, e.g., 8.2 (to build mex files)"
  option "with-tex", "Build documentation"

  deprecated_option "with-doc" => "with-tex"

  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "xz" => :build
  depends_on "fftw"
  depends_on :fortran
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "readline"
  depends_on "veclibfort"
  depends_on "octave" => :recommended
  depends_on "slicot" => "with-default-integer-8" if build.with? "matlab="
  depends_on "suite-sparse"
  depends_on :tex => [:build, :optional]

  if build.with? "tex"
    depends_on "doxygen" => :build
    depends_on "latex2html" => :build
    depends_on "texi2html" => :build
    depends_on "texinfo" => :build
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    matlab_path = ARGV.value("with-matlab") || ""
    matlab_version = ARGV.value("with-matlab-version") || ""
    no_matlab = matlab_path.empty? || matlab_version.empty?
    want_matlab = !matlab_path.empty? || !matlab_version.empty?

    if no_matlab
      if want_matlab
        opoo "Matlab support disabled: specify both Matlab path and version"
      end
      if build.without? "octave"
        odie "You must build Dynare with Matlab and/or Octave support"
      end
      args << "--disable-matlab"
    else
      args << "--with-matlab=#{matlab_path}"
      args << "MATLAB_VERSION=#{matlab_version}"
    end

    args << "--disable-octave" if build.without? "octave"

    if build.head?
      # Work around "Input line too long. (l. 104)"
      inreplace "dynare++/kord/journal.cweb",
        "#if !defined(__MINGW32__) && !defined(__CYGWIN32__) && !defined(__CYGWIN__) && !defined(__MINGW64__) && !defined(__CYGWIN64__)",
        "#if 1"

      inreplace "m4/ax_mexopts.m4",
        /MACOSX_DEPLOYMENT_TARGET='.*'/,
        "MACOSX_DEPLOYMENT_TARGET='#{MacOS.version}'"

      system "autoreconf", "-fvi"
    elsif build.stable?
      inreplace "mex/build/matlab/configure",
        /MACOSX_DEPLOYMENT_TARGET='.*'/,
        "MACOSX_DEPLOYMENT_TARGET='#{MacOS.version}'"
    end

    system "./configure", *args

    if build.with?("tex") && OS.mac?
      inreplace "doc/Makefile",
        "$(TEXI2PDF) $(AM_V_texinfo) --build-dir=$(@:.pdf=.t2p) -o $@ $(AM_V_texidevnull)",
        "$(TEXI2PDF) $(AM_V_texinfo) --build-dir=$(@:.pdf=.t2p) $(AM_V_texidevnull)"
    end

    system "make"
    system "make", "pdf" if build.with? "tex"
    system "make", "install"

    doc.install Dir.glob("doc/**/*.pdf")

    if build.with? "matlab="
      (prefix/"matlab.config").write <<-EOS.undent
        #{matlab_path}
        #{matlab_version}
      EOS
    end
  end

  def caveats; <<-EOS.undent
    To get started with dynare, open Matlab or Octave and type:

            addpath #{opt_prefix}/lib/dynare/matlab
    EOS
  end

  test do
    cp lib/"dynare/examples/bkk.mod", testpath
    if build.with? "octave"
      octave = Formula["octave"].opt_bin/"octave"
      system octave, "--no-gui", "-H", "--path", "#{lib}/dynare/matlab",
             "--eval", "dynare bkk.mod console"
    end

    if build.with? "matlab="
      matlab_path = File.read(prefix/"matlab.config").lines.first.chomp
      system "#{matlab_path}/bin/matlab", "-nosplash", "-nodisplay", "-r",
             "addpath #{lib}/dynare/matlab; dynare bkk.mod console; exit"
    end
  end
end
