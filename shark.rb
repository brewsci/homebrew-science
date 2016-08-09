class Shark < Formula
  desc "Machine leaning library"
  homepage "http://image.diku.dk/shark/"
  url "https://github.com/Shark-ML/Shark/archive/v3.1.1.tar.gz"
  sha256 "87ae435b34d1b0ac027f194ab41626f07077d60e7cd9ea8e7efc206cd43b69ca"

  bottle do
    sha256 "75eac173c7f64e9f342570dc7f7cf43fe55ce491e3a746423247738d5efb9e59" => :el_capitan
    sha256 "e3d0d42e5410a2aa4770c95a52a05c5a2e0557a4e8477505b6ae7c6a698d75bf" => :yosemite
    sha256 "15d81e7eeee7e39c4a1f85031978cb00ab178d0cad3fd2ab156cab633da965ce" => :mavericks
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
