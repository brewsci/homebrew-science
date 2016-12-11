class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "http://www.coin-or.org/CppAD"
  url "http://www.coin-or.org/download/source/CppAD/cppad-20150000.2.epl.tgz"
  version "20150000"
  sha256 "972498b307aff88173c4616e8e57bd2d1360d929a5faf49e3611910a182376f7"
  revision 2

  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "27925b4549da9289ed26e8be0fac4f3234e0d64cac28e757770804cd7caea78e" => :sierra
    sha256 "a962cd3acde16b1dca3359f6f80fd6a33c72cae97dd094e19f897a563b2f2c46" => :el_capitan
    sha256 "27925b4549da9289ed26e8be0fac4f3234e0d64cac28e757770804cd7caea78e" => :yosemite
    sha256 "95a1c4adc99f87b1de56a00ac34f7e844a9c1648eceac21f9042e9be09e4c9ea" => :x86_64_linux
  end

  option "with-eigen32", "Build with eigen support"
  option "with-openmp", "Build with OpenMP support"
  option "with-std", "Use std test vector"
  option "with-test", "Perform comprehensive tests (very slow w/out OpenMP)"

  deprecated_option "with-check" => "with-test"
  deprecated_option "with-eigen" => "with-eigen32"

  # Only one of --with-boost, --with-eigen32 and --with-std should be given.
  depends_on "adol-c" => :optional
  depends_on "boost" => :optional
  depends_on "cmake" => :build
  depends_on "homebrew/versions/eigen32" => :optional
  depends_on "ipopt" => :optional

  needs :cxx11 if build.with?("adol-c") || build.with?("ipopt")
  needs :openmp if build.with? "openmp"

  fails_with :gcc do
    build 5658
    cause <<-EOS.undent
      A bug in complex division causes failure of certain tests.
      See http://list.coin-or.org/pipermail/cppad/2013q1/000297.html
      EOS
  end

  def ipopt_options
    Tab.for_formula(Formula["ipopt"])
  end

  def install
    cmake_args = ["-Dcmake_install_prefix=#{prefix}",
                  "-Dcmake_install_docdir=share/doc"]

    cppad_testvector = "cppad"
    if build.with? "boost"
      cppad_testvector = "boost"
    elsif build.with? "eigen32"
      cppad_testvector = "eigen"
      cmake_args << "-Deigen_prefix=#{Formula["eigen32"].opt_prefix}"
      cmake_args << "-Dcppad_cxx_flags=-I#{Formula["eigen32"].opt_include}/eigen3"
    elsif build.with? "std"
      cppad_testvector = "std"
    end
    cmake_args << "-Dcppad_testvector=#{cppad_testvector}"

    if build.with? "adol-c"
      adolc_opts = Tab.for_name("adol-c").used_options
      cmake_args << "-Dadolc_prefix=#{Formula["adol-c"].opt_prefix}"
      cmake_args << "-Dcolpack_prefix=#{Formula["colpack"].opt_prefix}" unless adolc_opts.include? "without-colpack"
    end

    if build.with? "ipopt"
      cmake_args << "-Dipopt_prefix=#{Formula["ipopt"].opt_prefix}" if build.with? "ipopt"
      cmake_args << "-DCMAKE_EXE_LINKER_FLAGS=#{ENV.ldflags}" + ((ipopt_options.include? "with-openblas") ? "-L#{Formula["openblas"]}.lib -lopenblas" : "-lblas")
      # For some reason, ENV.cxx11 isn"t sufficient when building with gcc.
      cmake_args << "-Dcppad_cxx_flags=-std=c++11" if ENV.compiler != :clang
    end

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "check" if build.with? "test"
      system "make", "install"
    end
    pkgshare.install "example"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      # include <cassert>
      # include <cppad/thread_alloc.hpp>

      extern bool Acos(void);

      int main(void) {
        bool ok;
        ok = Acos();
        assert(ok);
        return static_cast<int>( ! ok );
      }
    EOS
    ENV.cxx11
    cxx_compile = ENV.cxx.split + ["-c", "#{pkgshare}/example/acos.cpp",
                                   "-I#{opt_include}"]
    if build.with? "eigen32"
      cxx_compile << "-I#{Formula["eigen32"].opt_include}/eigen3"
    end
    cxx_build = ENV.cxx.split + ["test.cpp", "-o", "test", "acos.o"]
    cd testpath do
      system *cxx_compile
      system *cxx_build
      system "./test"
    end
  end
end
