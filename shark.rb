class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.4.tar.gz"
  sha256 "160c35ddeae3f6aeac3ce132ea4ba2611ece39eee347de2faa3ca52639dc6311"
  revision 2

  bottle do
    cellar :any
    sha256 "3ae98a5a3b9f1e858f156ed9caf2dec299928ab3854290117bbe1745c890bc2c" => :sierra
    sha256 "6d8d6172e4a8977f63794355c9fd19b1e053f95f99617c70efc68fd2a73f9d8a" => :el_capitan
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
