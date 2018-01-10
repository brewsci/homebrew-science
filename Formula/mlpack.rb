class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://mlpack.org/files/mlpack-2.2.5.tar.gz"
  sha256 "e24e64d8451a3db23eafb7c94f9fa075dd540f5ac04953c82260a9d4d9fc4fcf"

  bottle do
    cellar :any
    sha256 "e9d8e97e3df78d48ccfff553fa46cfc6d61204133ce8bf86ead2022d43716ac4" => :high_sierra
    sha256 "dee66abdc8257caba52d37b69bd2e5514d9a697841182553cc309424913e7739" => :sierra
    sha256 "0bba3b4d17b38c2ca882b7f09fa694095674ef27853ffb140fc514cd143512e9" => :el_capitan
    sha256 "8a435c0e52162b282cb23bfb0b5f62fecbba5bc0bc2b87f1c5b89a11617af8be" => :x86_64_linux
  end

  option "with-debug", "Compile with debug options"
  option "with-profile", "Compile with profile options"
  option "with-test", "Run build-time tests"

  deprecated_option "with-check" => "with-test"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :run
  depends_on "armadillo"
  depends_on "boost"
  depends_on "libxml2"

  needs :cxx11

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j1" if ENV["CIRCLECI"]

    ENV.cxx11
    dylib = OS.mac? ? "dylib" : "so"
    cmake_args = std_cmake_args
    cmake_args << "-DDEBUG=" + (build.with?("debug") ? "ON" : "OFF")
    cmake_args << "-DPROFILE=" + (build.with?("profile") ? "ON" : "OFF")
    cmake_args << "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}"
    cmake_args << "-DARMADILLO_INCLUDE_DIR=#{Formula["armadillo"].opt_include}"
    cmake_args << "-DARMADILLO_LIBRARY=#{Formula["armadillo"].opt_lib}/libarmadillo.#{dylib}"
    cmake_args << "-DCMAKE_CXX_FLAGS=-fext-numeric-literals" unless ENV.compiler == :clang

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
