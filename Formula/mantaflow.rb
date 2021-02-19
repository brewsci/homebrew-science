class Mantaflow < Formula
  desc "Open computer graphics fluid simulation framework"
  homepage "http://mantaflow.com/"
  url "http://mantaflow.com/download/manta-src-0.11.tar.gz"
  sha256 "2aa1d26a85696dd233f6b2276c0ef3972192bf2e0e9abb908118ee427cc10463"
  head "https://bitbucket.org/mantaflow/manta.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, sierra:       "bb137ecbc8a0efa265ec19adf1996f5f58de77b84f1f98d254e7190871b31c04"
    sha256 cellar: :any_skip_relocation, el_capitan:   "7d6ef2b3b1d3a15507233df6457aa88679977b7c9e292e041f19c254f8ad29e8"
    sha256 cellar: :any_skip_relocation, yosemite:     "b97b356016cdd76ad11ba9308c718abb61c396e5a95a1d33964c08a40a0a41ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "852036ce8d4af5e981bcc397d932d956e6636e441051d45e38a9ec5e77ed5a3d"
  end

  option "with-openmp", "Build with OpenMP support"
  option "with-qt", "Build the QT GUI version"

  deprecated_option "with-qt5" => "with-qt"

  depends_on "cmake" => :build
  depends_on "python"
  depends_on "qt" => :optional

  needs :openmp if build.with? "openmp"

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
