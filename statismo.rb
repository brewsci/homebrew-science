class Statismo < Formula
  homepage "https://github.com/statismo/statismo"
  url "https://github.com/statismo/statismo/archive/v0.11.0.tar.gz"
  sha256 "f9b7109996d9e42e48b07923ea6edacca57b8ac7c573de1c905dbba921385c4c"
  head "https://github.com/statismo/statismo.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "97cd9accdb47d8187b9da59ff50df6ce9be04b0079429fd836f5eedc9264077f" => :yosemite
    sha256 "bde700f313bf3deae9f65fffc2e29851e5cac4adbec51278255f78a1a1b810e9" => :mavericks
    sha256 "1a628acd7e8df42a9fe9c109fa604ac51630d027a8e60cbd04144392334c4863" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "boost"
  depends_on "hdf5"
  depends_on "vtk"
  depends_on "insighttoolkit"

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DBUILD_EXAMPLES=ON
      -DBUILD_CLI_TOOLS=ON
      -DBUILD_DOCUMENTATION=OFF
      -DVTK_SUPPORT=ON
      -DITK_SUPPORT=ON
    ]
    args << ".."

    mkdir "statismo-build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/statismo-build-shape-model", "--help"
  end
end
