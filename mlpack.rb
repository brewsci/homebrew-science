class Mlpack < Formula
  desc "Scalable C++ machine learning library"
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://mlpack.org/files/mlpack-2.2.0.tar.gz"
  sha256 "31c3a14d5bdf34e7fdca57e589f363461cb328b0e58922b28e1a389aa1671bc1"
  revision 1

  bottle do
    cellar :any
    sha256 "5a1edf145db1f1dcceb855a0082cfe56920e0d37b2c58fff2f5c3aa3ade4a9e7" => :sierra
    sha256 "838049510eccc58c97cf3e5e9d68d738b78859d6b166b0fb77850c08eeefd509" => :el_capitan
    sha256 "5ce985b5e38c6e659067839d768fcb6226895c288aad6d0a106157a7bec6f505" => :yosemite
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
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j1" if ENV["CIRCLECI"]

    ENV.cxx11
    dylib = OS.mac? ? "dylib" : "so"
    cmake_args = std_cmake_args
    cmake_args << "-DDEBUG=" + ((build.with? "debug") ? "ON" : "OFF")
    cmake_args << "-DPROFILE=" + ((build.with? "profile") ? "ON" : "OFF")
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
