require "formula"

class Gromacs < Formula
  homepage "http://www.gromacs.org/"
  url "ftp://ftp.gromacs.org/pub/gromacs/gromacs-4.6.5.tar.gz"
  mirror "https://fossies.org/linux/privat/gromacs-4.6.5.tar.gz"
  sha1 "6bf86bb514e5488bda988d5b0e98867706d4ecd4"

  deprecated_option "with-x" => "with-x11"
  deprecated_option "enable-mpi" => "with-mpi"

  option "enable-double","Enables double precision"
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

    inreplace "scripts/CMakeLists.txt", "BIN_INSTALL_DIR", "DATA_INSTALL_DIR"

    cd "src" do
      system "cmake", "..", *args
      system "make"
      system "make", "test" if build.with? "check"
      ENV.deparallelize
      system "make", "install"
    end

    bash_completion.install "scripts/completion.bash" => "gromacs-completion.bash"
    zsh_completion.install "scripts/completion.zsh" => "_gromacs"
  end

  def caveats;  <<-EOS.undent
    GMXRC and other scripts installed to:
      #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end
end
