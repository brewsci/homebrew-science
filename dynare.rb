require "formula"

class Dynare < Formula
  homepage "http://www.dynare.org"
  url "https://www.dynare.org/release/source/dynare-4.4.3.tar.xz"
  sha1 "3c99c3a957d02e53db62cba7566fdb1399438cfc"

  option "with-matlab=", "Path to Matlab root directory (to build mex files)"
  option "with-matlab-version=", "Matlab version, e.g., 8.2 (to build mex files)"
  option "with-doc", "Build documentation"
  option "without-check", "Disable build-time checks (not recommended)"

  depends_on "boost" => :build
  depends_on "xz"    => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on "libmatio"
  depends_on "matlab2tikz"
  depends_on :fortran

  depends_on :tex      => :build if build.with? "doc"
  depends_on "doxygen" => :build if build.with? "doc"

  depends_on "slicot" => ["with-default-integer-8"] if build.with? "matlab="
  depends_on "octave" => :recommended

  def install
    args=%W[
            --disable-debug
            --disable-dependency-tracking
            --disable-silent-rules
            --prefix=#{prefix}
    ]
    matlab_path = ARGV.value("with-matlab") || ""
    matlab_version = ARGV.value("with-matlab-version") || ""
    if (matlab_path.empty? or matlab_version.empty?) and build.without? "octave"
      onoe("You must build Dynare with Matlab and/or Octave support")
      exit 1
    end
    if matlab_path.empty? or matlab_version.empty?
      if not (matlab_path.empty? and matlab_version.empty?)
        opoo "Matlab support disabled: specify both Matlab path and version"
      end
      args << "--disable-matlab"
    else
      args << "--with-matlab=#{matlab_path}"
      args << "MATLAB_VERSION=#{matlab_version}"
    end
    args << "--disable-octave" if build.without? "octave"

    system "./configure", *args

    if build.with? "doc" and OS.mac?
      inreplace "doc/Makefile", \
                "$(TEXI2PDF) $(AM_V_texinfo) --build-dir=$(@:.pdf=.t2p) -o $@ $(AM_V_texidevnull)", \
                "$(TEXI2PDF) $(AM_V_texinfo) --build-dir=$(@:.pdf=.t2p) $(AM_V_texidevnull)"
    end

    system "make", "pdf" if build.with? "doc"
    system "make install"

    # Install documentation by hand
    if build.with? "doc"
      doc.install Dir["doc/*.pdf"]
      doc.install "doc/macroprocessor/macroprocessor.pdf", \
      "doc/parallel/parallel.pdf", "doc/preprocessor/preprocessor.pdf", \
      "doc/userguide/UserGuide.pdf", "doc/gsa/gsa.pdf"
    end

    # Record Matlab info.
    if build.with? "matlab="
      File.open(prefix / "matlab.config", "w") do |f|
        f.puts(matlab_path)
        f.puts(matlab_version)
      end
    end
  end

  test do
    copy("#{lib}/dynare/examples/bkk.mod", testpath)
    if build.with? "octave"
      system "octave --no-gui -H " \
        "--path #{opt_prefix}/lib/dynare/matlab " \
        "--eval 'dynare bkk.mod console'"
    end

    if build.with? "matlab="
      matlab_path = File.open(prefix / "matlab.config") {|f| f.gets.chomp}
      system "#{matlab_path}/bin/matlab -nosplash -nodisplay " \
        "-r 'addpath #{opt_prefix}/lib/dynare/matlab; dynare bkk.mod console; exit'"
    end
  end

  def caveats
    s = <<-EOS.undent
    To get started with dynare, open Matlab or Octave and type:

            addpath #{opt_prefix}/lib/dynare/matlab
    EOS
  end
end
