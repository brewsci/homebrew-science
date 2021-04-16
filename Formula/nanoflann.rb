class Nanoflann < Formula
  desc "C++ header-only library for Nearest Neighbor search wih KD-trees"
  homepage "https://jlblancoc.github.io/nanoflann/"
  url "https://github.com/jlblancoc/nanoflann/archive/v1.2.3.tar.gz"
  sha256 "5ef4dfb23872379fe9eb306aabd19c9df4cae852b72a923af01aea5e8d7a59c3"

  head "https://github.com/jlblancoc/nanoflann.git"

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 cellar: :any_skip_relocation, sierra:       "1ace2e2e1bb328cbce2c92c1a46970dcee5012ddae023274567a631a052b0cc3"
    sha256 cellar: :any_skip_relocation, el_capitan:   "1ace2e2e1bb328cbce2c92c1a46970dcee5012ddae023274567a631a052b0cc3"
    sha256 cellar: :any_skip_relocation, yosemite:     "1ace2e2e1bb328cbce2c92c1a46970dcee5012ddae023274567a631a052b0cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ca47b76a7411c34e13ca50f496a1e48bd347d07eaf3e544cad824f9fe0c6a505"
  end

  depends_on "cmake" => :build

  def install
    # disable examples because there's no install mechanism
    inreplace "CMakeLists.txt", "add_subdirectory(examples)", ""

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test"
    system "./test"
  end
end
