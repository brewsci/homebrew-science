class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.3.tar.gz"
  sha256 "eae0f4fa8649aaa4e1809860697373cea20f64defd8c12e3ed6014ec1a2f1b89"

  bottle do
    cellar :any
    sha256 "65fb8571660c52bc94c20272c851e010f657f275f850590afa4728589adf8765" => :el_capitan
    sha256 "7cf6ec0decb6795e7cebe8abd5d9501e15333672b21ad9c68a1a97a44e4ed0c2" => :yosemite
    sha256 "536853ce249e438b35fa3e49ba1c54f5ac3c5493bf3bc33c9374c13ebcaa20f8" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"data.csv").write <<-EOS.undent
      1 1 0
      2 2 1
    EOS

    (testpath/"test.cpp").write <<-EOS.undent
      #include <shark/Data/Csv.h>
      using namespace shark;

      int main() {
        ClassificationDataset data;
        importCSV(data, "data.csv", LAST_COLUMN, ' ');
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lshark",
           "-L#{Formula["boost"].lib}", "-lboost_serialization",
           "-I#{Formula["boost"].include}"
    system "./test"
  end
end
