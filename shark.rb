class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.4.tar.gz"
  sha256 "160c35ddeae3f6aeac3ce132ea4ba2611ece39eee347de2faa3ca52639dc6311"
  revision 1

  bottle do
    cellar :any
    sha256 "aacf8b4bcaf6fc2906ec629ca72e7bce0e8eaf7a65373510df989e481215392c" => :sierra
    sha256 "97cd77c824dd1e79091787a6bfa0c8e299d31cbbf8df8791f72799039bf1a81a" => :el_capitan
    sha256 "a7557629cc00e66f6439ec10626ed5b6069b21aa47d608990162c870ccd8e423" => :yosemite
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
