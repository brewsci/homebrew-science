class Mantaflow < Formula
  desc "Open computer graphics fluid simulation framework"
  homepage "http://mantaflow.com/"
  url "http://mantaflow.com/download/manta-src-0.11.tar.gz"
  sha256 "2aa1d26a85696dd233f6b2276c0ef3972192bf2e0e9abb908118ee427cc10463"
  head "https://bitbucket.org/mantaflow/manta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad355d211ffb8c2dcfead2cc2b21f893131091f07e75ef9474e4160938c3fa10" => :sierra
    sha256 "acdf534da3b63b86efe5ef35fa820bf909ee8eb6a40e5379ebc77324be14ac31" => :el_capitan
    sha256 "541acdf33fbdbcb57df0d439de413db475c2073d30509715960c63c143c18790" => :yosemite
    sha256 "b7b594c99940e2494e61d8b872a4626e0f4a22822c044e127b674314ae847b8e" => :x86_64_linux
  end

  deprecated_option "with-qt5" => "with-qt"

  option "with-openmp", "Build with OpenMP support"
  option "with-qt", "Build the QT GUI version"

  depends_on "cmake" => :build
  depends_on "qt" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  needs :openmp if build.with? "openmp"
  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args

    args << "-DOPENMP=ON" if build.with? "openmp"
    args << "-DGUI=ON" if build.with? "qt"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"

      bin.install "manta"

      # Symlink 'mantaflow' to avoid confusion when getting started with mantaflow
      # Actual command is 'manta'
      bin.install_symlink "manta" => "mantaflow"
    end

    # Copy the python sample scene files
    pkgshare.install Dir["scenes/*"]
  end

  test do
    touch "foo.py"
    assert_match "Script finished.", shell_output("#{bin}/manta foo.py")
  end
end
