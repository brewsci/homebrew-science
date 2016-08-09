class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.1.tar.gz"
  sha256 "87ae435b34d1b0ac027f194ab41626f07077d60e7cd9ea8e7efc206cd43b69ca"

  bottle do
    sha256 "f4441c3e99bec7049d2694ef96e337dd452e1fa84c914fbc7be1c0e544dfe831" => :el_capitan
    sha256 "c6ad00f988a65776d81eb21de5cd070368bfefbb41c5e1a147bc2b591a90c070" => :yosemite
    sha256 "ac84e035d32327e7f019bac93b276f7a42cd132eb184cf324f3f6ffce83ccfe5" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "homebrew/versions/boost160"

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
           "-L#{Formula["boost160"].lib}", "-lboost_serialization",
           "-I#{Formula["boost160"].include}"
    system "./test"
  end
end
