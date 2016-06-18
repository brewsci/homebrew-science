class Mlpack < Formula
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://www.mlpack.org/files/mlpack-2.0.1.tar.gz"
  sha256 "87305f7003e060d3c93d60ce1365c4ec0fa7e827c356e857be316b0e54114f22"
  revision 1

  bottle do
    cellar :any
    sha256 "8e19f5d05105b60ff7c9437e6e2604e3d44c8e0090b335b9e1e4426c3df40b23" => :el_capitan
    sha256 "f314365938a94d00d350c94291cb05ccf6c934e026859d256bba3f4a7aa8e6b7" => :yosemite
    sha256 "f2a09ab8b1d87c1c7b18221c2ecb866fe424a5e7d24d900b4dd687465c0b747c" => :mavericks
  end

  needs :cxx11
  cxx11dep = MacOS.version < :mavericks ? ["c++11"] : []

  depends_on "cmake" => :build
  depends_on "libxml2"
  depends_on "armadillo" => ["with-hdf5"] + cxx11dep
  depends_on "boost" => cxx11dep
  depends_on "txt2man" => :optional

  option "with-debug", "Compile with debug options"
  option "with-profile", "Compile with profile options"
  option "with-check", "Run build-time tests"

  def install
    ENV.cxx11
    dylib = OS.mac? ? "dylib" : "so"
    cmake_args = std_cmake_args
    cmake_args << "-DDEBUG=" + ((build.with? "debug") ? "ON" : "OFF")
    cmake_args << "-DPROFILE=" + ((build.with? "profile") ? "ON" : "OFF")
    cmake_args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    cmake_args << "-DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}"
    cmake_args << "-DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib}/libarmadillo.#{dylib}"

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "test" if build.with? "check"
      system "make", "install"
    end

    doc.install Dir["doc/*"]
    (share / "mlpack").install "src/mlpack/tests" # Includes test data.
  end

  test do
    ENV.cxx11
    cd testpath do
      system "#{bin}/mlpack_allknn",
        "-r", "#{share}/mlpack/tests/data/GroupLens100k.csv",
        "-n", "neighbors.csv",
        "-d", "distances.csv",
        "-k", "5", "-v"
    end

    (testpath / "test.cpp").write <<-EOS
      #include <mlpack/core.hpp>

      using namespace mlpack;

      int main(int argc, char** argv) {
        CLI::ParseCommandLine(argc, argv);
        Log::Debug << "Compiled with debugging symbols." << std::endl;
        Log::Info << "Some test informational output." << std::endl;
        Log::Warn << "A false alarm!" << std::endl;
      }
      EOS
    cxx_with_flags = ENV.cxx.split + ["test.cpp", "-I#{include}", "-I#{Formula["libxml2"].opt_include}/libxml2",
           "-L#{lib}", "-lmlpack", "-o", "test"]
    system *cxx_with_flags
    system "./test", "--verbose"
  end
end
