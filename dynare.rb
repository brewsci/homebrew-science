class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org"
  url "https://www.dynare.org/release/source/dynare-4.5.1.tar.xz"
  sha256 "ae6a7e9cc62fb25b18db3d4b5c34c27c7af17a46cb73586d051a049b7108db1f"

  bottle do
    sha256 "e0b8055f4d626d1ac81818ff2b09ef649720012233ef50e8a0a48323240491be" => :sierra
    sha256 "a5513ba8621f39815d5ce17bc646425b5111033e0d273a9bde49e53015cadf4e" => :el_capitan
    sha256 "d6085bc0705de071bd3b901995a0539fd580ef1423ee9889b750c1588c211f7a" => :yosemite
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
