class Mlpack < Formula
  homepage "http://www.mlpack.org"
  # doi "arXiv:1210.6293"
  url "http://www.mlpack.org/files/mlpack-1.0.12.tar.gz"
  sha256 "f47abfc2ab75f1d7f4c73a3368c4428223f025cc6fbc6703735df6a2734a838c"
  revision 2

  bottle do
    cellar :any
    sha256 "163f8d2e87dcc400c5822973ea1f086674eb2169c439a1974a7fd0bd8725157f" => :el_capitan
    sha256 "a0e408c206a0892da947e8df082d61261667b3b9df1901477983abe6da98eb96" => :yosemite
    sha256 "9602fa0e506fc73eef29fa0b08ea33f4319b908672cb5f0de3337572bcce4394" => :mavericks
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
