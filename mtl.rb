class Mtl < Formula
  homepage "http://www.simunova.com"
  url "http://www.simunova.com/downloads/mtl4/MTL-4.0.9555-Linux.tar.bz2"
  sha256 "b747922b25ccf3192de7f8a6b2035705d415ccbebc5d90dd9538a7087539008d"
  revision 2

  bottle :disable, "needs to be rebuilt with latest boost"

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
