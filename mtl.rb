class Mtl < Formula
  homepage "http://www.simunova.com"
  url "http://www.simunova.com/downloads/mtl4/MTL-4.0.9555-Linux.tar.bz2"
  sha256 "b747922b25ccf3192de7f8a6b2035705d415ccbebc5d90dd9538a7087539008d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f9f254b05d47d34e18e570902cbf90eefa4ffa1eae47cf50f635c66ebed6fb8" => :el_capitan
    sha256 "d164d9820f22e7edb98e56261a67b6955ddd4fcc284a91a2071f167ce7cbe922" => :yosemite
    sha256 "9a2a5047bd351256a2acef3122e51539d12c0dfc8bf72c02cec8e032f43ff558" => :mavericks
  end

  head do
    url "https://simunova.zih.tu-dresden.de/svn/mtl4/trunk", :using => :svn
    depends_on "cmake" => :build
  end

  depends_on "boost"

  def install
    if build.head?
      system "cmake", "-DENABLE_TESTS=OFF", ".", *std_cmake_args
      system "make", "install"
    else
      prefix.install "usr/include", "usr/share"
    end
  end

  test do
    (testpath/"vector1.cpp").write <<-EOS.undent
      // copied from http://www.simunova.com/node/144
      #include <iostream>
      #include <boost/numeric/mtl/mtl.hpp>

      int main(int, char**) {
          using namespace mtl;
          dense_vector<double> v(10, 0.0);
          v[7]= 3.0;
          std::cout << "v is " << v << "\\n";
          return 0;
      }
    EOS

    system ENV.cxx, "-I#{include}", "-I#{Formula["boost"].include}",
      "vector1.cpp", "-o", "vector1"
    system "./vector1"
  end
end
