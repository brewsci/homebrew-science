class Mantaflow < Formula
  desc "Open computer graphics fluid simulation framework"
  homepage "http://mantaflow.com/"
  url "http://mantaflow.com/download/manta-src-0.9.tar"
  sha256 "f55298f10650b35454f3134d2d0e265b19c24c3c68991e4bbedf5a460be67077"
  head "https://bitbucket.org/mantaflow/manta.git"

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
