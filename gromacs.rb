class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2016.3.tar.gz"
  sha256 "7bf00e74a9d38b7cef9356141d20e4ba9387289cbbfd4d11be479ef932d77d27"
  # tag "chemistry"
  # doi "10.1016/0010-4655(95)00042-E"

  bottle do
    sha256 "b714b0a00dd7373cc13f9ac3d636a7d763db59eb8744434353cf877cdcdd0f70" => :sierra
    sha256 "f826d021ed91e9e7fe63c8821bfb09bdbd311287fde9c8b21488c9b57be29ee6" => :el_capitan
    sha256 "131cff727b5314243d47fb743083d5629ffd9615de25da50ebce58e1097ddafd" => :yosemite
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
