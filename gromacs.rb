class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.1.tar.gz"
  mirror "https://fossies.org/linux/privat/gromacs-5.1.1.tar.gz"
  sha256 "9316fd0be320e2dd8c048f905df5be115e1b230c4ca4f3a7ef5892a1fc0bc212"
  revision 1

  bottle do
    sha256 "8a7b09bbb64edff8c203b6db0240c048f209e0c44053c9d25a36a45dea3cc98a" => :el_capitan
    sha256 "aa22e73e1eb9a00c135979a3841820e569efbb2e235ef520a9370e1cc59152da" => :yosemite
    sha256 "2371754e9219570eddae802ecdac677777ba8d79dd8072030845a649c7c20d58" => :mavericks
  end

  deprecated_option "with-x" => "with-x11"
  deprecated_option "enable-mpi" => "with-mpi"
  deprecated_option "enable-double" => "with-double"

  option "with-double", "Enables double precision"
  option "without-check", "Skip build-time tests (not recommended)"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl" => :recommended
  depends_on :mpi => :optional
  depends_on :x11 => :optional

  def install
    args = std_cmake_args
    args << "-DGMX_GSL=ON" if build.with? "gsl"
    args << "-DGMX_MPI=ON" if build.with? "mpi"
    args << "-DGMX_DOUBLE=ON" if build.include? "enable-double"
    args << "-DGMX_X11=ON" if build.with? "x11"
    args << "-DGMX_CPU_ACCELERATION=None" if MacOS.version <= :snow_leopard
    args << "-DREGRESSIONTEST_DOWNLOAD=ON" if build.with? "check"

    inreplace "scripts/CMakeLists.txt", "BIN_INSTALL_DIR", "DATA_INSTALL_DIR"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "check" if build.with? "check"
      ENV.deparallelize
      system "make", "install"
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install "#{bin}/gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install "#{bin}/gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats; <<-EOS.undent
    GMXRC and other scripts installed to:
      #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "gmx", "help"
  end
end
