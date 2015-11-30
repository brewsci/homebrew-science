class Shark < Formula
  desc "Machine leaning library"
  homepage "http://shark-project.sourceforge.net/"
  url "https://github.com/Shark-ML/Shark/archive/v3.0.0.tar.gz"
  sha256 "b8b3bc9dca52369d4cc432b99ebdd37450056eb1b6ce86070996f16ea44d09ea"

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

    system ENV.cxx, "test.cpp", "-o", "test",
      "-I#{include}", "-L#{lib}", "-lshark", "-lboost_serialization"
    system "./test"
  end
end
