class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.1.tar.gz"
  mirror "https://fossies.org/linux/privat/gromacs-5.1.1.tar.gz"
  sha256 "9316fd0be320e2dd8c048f905df5be115e1b230c4ca4f3a7ef5892a1fc0bc212"
  revision 1

  bottle do
    sha256 "cde5058f7d151279fed145dd182b01d18559848a4adc74ce86d41e10779d708d" => :el_capitan
    sha256 "f176d88962f0621f91d0a4f628e955add8e140c47a4165be9d5720325bd3eb36" => :yosemite
    sha256 "f23f45a532e1b46ec038bfd524c50aa100d772838798564bfe0be1bb44f56edb" => :mavericks
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
