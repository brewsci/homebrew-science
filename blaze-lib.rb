class BlazeLib < Formula
  desc "C++ math library for dense and sparse arithmetic"
  homepage "https://bitbucket.org/blaze-lib/blaze/"
  url "https://bitbucket.org/blaze-lib/blaze/downloads/blaze-2.4.tar.gz"
  sha256 "34af70c8bb4da5fd0017b7c47e5efbfef9aadbabc5aae416582901a4059d1fa3"

  bottle do
    cellar :any
    sha256 "4d58ed7bb8c63e505f03eb3ffeb34eb55bd79818312a5820f63f4a61831e6e91" => :yosemite
    sha256 "838874d5429101af07e4583f0e3b55f85604910ab50faaaa67d7ec77b1fd43da" => :mavericks
    sha256 "69b6cee54d526855674a5001145581d77c4ac40870c05cdd8ca6b1722533581e" => :mountain_lion
  end

  depends_on "boost"

  def install
    inreplace "Configfile", "CXX=\"g++\"", "CXX=\"#{ENV.cxx}\""

    # Set compiler flags for intel C++ compiler
    if ENV.cxx.include? "icpc"
      inreplace "Configfile", "CXXFLAGS=\"-Werror -Wall -Wextra -Wshadow -Woverloaded-virtual -ansi -O3 -DNDEBUG\"", "CXXFLAGS=\"-Werror -Wshadow -w1 -ansi -O3 -DNDEBUG\""
    end

    system "./configure"
    system "make"

    include.install "blaze"
    lib.install "lib/libblaze.a"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <blaze/Blaze.h>

      using blaze::StaticVector;
      using blaze::DynamicVector;

      int main(int argc, char *argv[])
      {
        // Instantiation of a static 3D column vector. The vector is directly initialized as
        StaticVector<int,3UL> a( 4, -2, 5 );

        // Instantiation of a dynamic 3D column vector. Via the subscript operator the values are set to
        DynamicVector<int> b( 3UL );
        b[0] = 2;
        b[1] = 5;
        b[2] = -3;

        // Adding the vectors a and b
        DynamicVector<int> c = a + b;

        return (c[0] == 6 && c[1] == 3 && c[2] == 2) ? 0 : -1;
      }
    EOS

    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{include}
      -lblaze
      -lboost_system
    ]
    system ENV.cxx, "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
