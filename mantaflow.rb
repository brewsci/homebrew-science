class Mantaflow < Formula
  desc "Open computer graphics fluid simulation framework"
  homepage "http://mantaflow.com/"
  url "http://mantaflow.com/download/manta-src-0.10.tar"
  sha256 "cab98dd38ded26a65ad151ce1cd2dafd93be8f94b3668e873cbfca73748fdc57"
  head "https://bitbucket.org/mantaflow/manta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c2492c7b3cd0f825e80486c225642a515d3f3b1a1f9d9dcc4ac103475817655" => :sierra
    sha256 "442c1cffdd96fe3c1eb86e00a557635c2c03b6c8f470673616bbc86ad4e1d5d4" => :el_capitan
    sha256 "25fbf001e16904d62707c5afde072b15db201ed041fbe8b9f1bbeaea2cfd72a6" => :yosemite
    sha256 "259daeb28c40f9030f260ded9c1bb560f7c24d602fa48557b180fb8090910028" => :x86_64_linux
  end

  option "with-openmp", "Build with OpenMP support"
  option "with-qt5", "Build the QT GUI version"

  depends_on "cmake" => :build
  depends_on "qt5" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

  needs :openmp if build.with? "openmp"
  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args

    args << "-DOPENMP=ON" if build.with? "openmp"
    args << "-DGUI=ON" if build.with? "qt5"

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
