class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org"
  url "https://www.dynare.org/release/source/dynare-4.5.1.tar.xz"
  sha256 "ae6a7e9cc62fb25b18db3d4b5c34c27c7af17a46cb73586d051a049b7108db1f"

  bottle do
    sha256 "bd5f20ad0a816676f72a1d2173fb9dc49da7a429e6c0177766beb2e932f0dc89" => :sierra
    sha256 "90cf6f57d3793a60528f35f17e70536275c52cbb9846e5536deefcd685e5d789" => :el_capitan
    sha256 "81abb18baf002f44de3f28350c9dac98918a244405ab097b268880cf470d550e" => :yosemite
  end

  head do
    url "https://github.com/DynareTeam/dynare.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  option "with-matlab=", "Path to Matlab root directory (to build mex files)"
  option "with-matlab-version=", "Matlab version, e.g., 8.2 (to build mex files)"

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
  depends_on "veclibfort" if OS.mac?
  depends_on "octave" => :recommended
  depends_on "slicot"
  depends_on "suite-sparse"

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

    system "make"
    system "make", "install"

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
