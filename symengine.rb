class Symengine < Formula
  desc "Symbolic manipulation library, written in C++"
  homepage "https://github.com/symengine/symengine"
  url "https://github.com/symengine/symengine/archive/v0.2.0.tar.gz"
  sha256 "64d050b0b9decd12bf4ea3b7d18d3904dd7cb8baaae9fbac1b8068e3c59709be"
  head "https://github.com/symengine/symengine.git"

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
