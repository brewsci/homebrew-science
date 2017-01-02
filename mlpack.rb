class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://www.mlpack.org/files/mlpack-2.1.1.tar.gz"
  sha256 "c2249bbab5686bb8658300ebcf814b81ac7b8050a10f1a517ba5530c58dbac31"

  bottle do
    cellar :any
    sha256 "b31b8e23801b08d312e126aa300b646845b0d248385ecf07b5d2adf3ed41b7b4" => :sierra
    sha256 "dc3e140af614270909914f882222bf36a62b3590a5b3617dbc6a071d74760118" => :el_capitan
    sha256 "50fbfc3abe3ebedfd66a2bb8ac66d9ce154cd5a17c29b048f8700f2853d8cbdd" => :yosemite
  end

  needs :cxx11
  cxx11dep = MacOS.version < :mavericks ? ["c++11"] : []

  deprecated_option "with-check" => "with-test"

  option "with-debug", "Compile with debug options"
  option "with-profile", "Compile with profile options"
  option "with-test", "Run build-time tests"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :run
  depends_on "libxml2"
  depends_on "armadillo" => ["with-hdf5"] + cxx11dep
  depends_on "boost" => cxx11dep

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
    pkgshare.install "src/mlpack/tests" # Includes test data.
  end

  test do
    ENV.cxx11
    cd testpath do
      system "#{bin}/mlpack_knn",
        "-r", "#{pkgshare}/tests/data/GroupLens100k.csv",
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
    cxx_with_flags = ENV.cxx.split + ["test.cpp", "-I#{include}",
                                      "-I#{Formula["libxml2"].opt_include}/libxml2",
                                      "-L#{lib}", "-lmlpack",
                                      "-o", "test"]
    system *cxx_with_flags
    system "./test", "--verbose"
  end
end
