class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.4.tar.gz"
  sha256 "160c35ddeae3f6aeac3ce132ea4ba2611ece39eee347de2faa3ca52639dc6311"
  revision 1

  bottle do
    cellar :any
    sha256 "19232b0e4798850da95f45b2d2dcf7dabea20e842540b7f37d41c40e96cdbfee" => :sierra
    sha256 "ee137fc10bdbb203c213144487bd55976760a657053c216758b907845202fc74" => :el_capitan
    sha256 "6b5cf899fa64c713865d4ddb078146e94c4fdf9b2012d80c4b9ed3454b74c864" => :yosemite
    sha256 "c9a897fd30e21c08f256c3b842b62936f0467ac8ad24d5dc6847aabeda9683ea" => :x86_64_linux
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
