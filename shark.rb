class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.2.tar.gz"
  sha256 "73d77860494bee2b5f36d492773ddb9ea7da864d2ce2d38b3abce673e9f1c4ab"

  bottle do
    cellar :any
    sha256 "80b7a08e5f6f6a76b3fcf8bbdca72ef02dc14fd822ed2ef10041908d9339e024" => :el_capitan
    sha256 "0427ea59bb0d23a1eb70717babe5a722afd46c3b9051e0cbf479be07ea0c939f" => :yosemite
    sha256 "8ef6293010b5039c9add3dbd82dda302973d3ee2dfcf97fae948ec277270bf66" => :mavericks
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
