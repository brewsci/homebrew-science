class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://www.mlpack.org/files/mlpack-2.1.0.tar.gz"
  sha256 "2ebe79990b6a5ec5e6e0d2de6e13ae11c8e33af16f6eeb0f9f7e1ee650c72499"

  bottle do
    cellar :any
    sha256 "48f10140f8b8a464c44c0ce950b9e60f04ab55f778c5fb26431a0886a840a34c" => :sierra
    sha256 "b27bab440ade7e96327f0a1d3309a383777406f0b3c280f16cae879401d1914c" => :el_capitan
    sha256 "bda1ca9225c0a79f6516e7baa2d0d8dc58347957618fbe555c7383f59a4c0f0e" => :yosemite
  end

  needs :cxx11
  cxx11dep = MacOS.version < :mavericks ? ["c++11"] : []

  deprecated_option "with-check" => "with-test"

  option "with-debug", "Compile with debug options"
  option "with-profile", "Compile with profile options"
  option "with-test", "Run build-time tests"

  depends_on "cmake" => :build
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
