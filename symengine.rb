class Symengine < Formula
  desc "Symbolic manipulation library, written in C++"
  homepage "https://github.com/symengine/symengine"
  url "https://github.com/symengine/symengine/archive/v0.3.0.tar.gz"
  sha256 "591463cb9e741d59f6dfd39a7943e3865d3afe9eac47d1a9cbf5ca74b9c49476"
  head "https://github.com/symengine/symengine.git"

  bottle do
    cellar :any
    sha256 "6e223e1128ccb85adcb29786f486647e6b67e007185e289912496a416a3b139c" => :sierra
    sha256 "2a4a25ee3df6baf76ebfcaeb11736a823ce162183b1a6efa935e8ef1fe5a2468" => :el_capitan
    sha256 "0ef7fa831900d49bebc874eaf464d6aa422245720079dcef2967816a105e00e8" => :yosemite
    sha256 "db0653b3e9b2484d3143593f7a8b80a6118fa8dd7addb2a9d2404aec056fe198" => :x86_64_linux
  end

  option "without-test", "Skip build-time tests (not recommended)"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"

  needs :cxx11

  def install
    ENV.cxx11
    args = std_cmake_args + [
      "-DCMAKE_PREFIX_PATH=#{Formula["gmp"].opt_prefix};#{Formula["mpfr"].opt_prefix};#{Formula["libmpc"].opt_prefix}",
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
      "-DBUILD_BENCHMARKS=no",
      "-DINTEGER_CLASS=gmp",
      "-DWITH_SYMENGINE_THREAD_SAFE=yes",
      "-DWITH_MPC=yes",
      "-DBUILD_FOR_DISTRIBUTION=yes",
      "-DBUILD_SHARED_LIBS=yes",
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "ctest" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <symengine/expression.h>
      #include <symengine/symbol.h>
      using SymEngine::Expression;
      using SymEngine::symbol;

      int main(int argc, char* argv[])
      {
          Expression x(symbol("x"));
          auto y = x * x + 2 * x + 1;
          return EXIT_SUCCESS;
      }
    EOS

    ENV.cxx11
    cmd = [ENV["CXX"], "test.cpp", "-lsymengine", "-lmpc", "-lmpfr", "-lgmp", "-o", "test"]
    system cmd.join(" ")
    system "./test"
  end
end
