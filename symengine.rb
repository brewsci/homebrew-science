class Symengine < Formula
  desc "Symbolic manipulation library, written in C++"
  homepage "https://github.com/symengine/symengine"
  url "https://github.com/symengine/symengine/archive/v0.2.0.tar.gz"
  sha256 "64d050b0b9decd12bf4ea3b7d18d3904dd7cb8baaae9fbac1b8068e3c59709be"
  head "https://github.com/symengine/symengine.git"

  bottle do
    cellar :any
    sha256 "a37356c660c4b252db18c695a3e3016c603d4bcb7a1a46718452c66a5f0a04db" => :sierra
    sha256 "b60d93688e3e13457051e91331f4a67a7332088575ff6d54c398c97e278a1d34" => :el_capitan
    sha256 "dbeaa3317ec41b763eef90ee6a372a024b9d9f99bc525c0ac4e6ec8eb72e5afa" => :yosemite
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
