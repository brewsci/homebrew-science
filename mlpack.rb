class Mlpack < Formula
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://www.mlpack.org/files/mlpack-1.0.12.tar.gz"
  sha256 "f47abfc2ab75f1d7f4c73a3368c4428223f025cc6fbc6703735df6a2734a838c"
  revision 2

  bottle do
    cellar :any
    sha256 "f7fa9efb1d6d75f651be3768d940d144db0742f01a500db4221c9b3b085fc9fc" => :el_capitan
    sha256 "7d0f0d82b3ebf2f87c5726057dae0c0ca6ea5074cd890e6c8213aef02eb3dae0" => :yosemite
    sha256 "61698e951d7139f5ae272e16f43678c6340ec55ab1df788e3c3969126f0d0e1e" => :mavericks
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
    cd testpath do
      system "#{bin}/allknn",
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
    system ENV.cxx, "-stdlib=libc++", "test.cpp",
           "-I#{include}", "-I#{Formula["libxml2"].opt_include}/libxml2",
           "-L#{lib}", "-lmlpack", "-o", "test"
    system "./test", "--verbose"
  end
end
