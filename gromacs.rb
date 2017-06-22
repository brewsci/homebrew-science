class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.1.4.tar.gz"
  mirror "https://fossies.org/linux/privat/gromacs-5.1.4.tar.gz"
  sha256 "0f3793d8f1f0be747cf9ebb0b588fb2b2b5dc5acc32c3046a7bee2d2c03437bc"
  revision 1
  # tag "chemistry"
  # doi "10.1016/0010-4655(95)00042-E"

  bottle do
    sha256 "9eada79b13902b80ccc076e964cceee7a464e0f0ad89f069e31bd88b973ba7cb" => :sierra
    sha256 "81f64dd4b5843d4cc24f38deff0717726aa1f118d61f70ad681f6f02f667d52b" => :el_capitan
    sha256 "6c2fc2e5cfe7b335140a3cbdeec8eeafd3503851d9d1fde49d2dcdf4d6ca9482" => :yosemite
  end

  deprecated_option "with-x" => "with-x11"
  deprecated_option "enable-mpi" => "with-mpi"
  deprecated_option "enable-double" => "with-double"
  deprecated_option "without-check" => "without-test"

  option "with-double", "Enables double precision"
  option "without-test", "Skip build-time tests (not recommended)"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl" => :recommended
  depends_on :mpi => :optional
  depends_on :x11 => :optional
  unless OS.mac?
    depends_on "openblas"
    depends_on "zlib"
  end

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
    system "#{bin}/gmx", "help"
  end
end
