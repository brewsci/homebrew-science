class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "http://www.coin-or.org/CppAD"
  url "http://www.coin-or.org/download/source/CppAD/cppad-20150000.2.epl.tgz"
  version "20150000"
  sha256 "972498b307aff88173c4616e8e57bd2d1360d929a5faf49e3611910a182376f7"
  revision 1

  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b90c1f1709158d93485537a9f5b0b73ce8062da77023d75e57b636a04263c93" => :el_capitan
    sha256 "b843ac6f64006d4e792b439cbe0d3c038187d58824d1f6c651db9eb5aba6a07a" => :yosemite
    sha256 "b739ab58539af282bee36a95d4520e37259d4a7b8439efea90c816c8e32d12d8" => :mavericks
  end

  deprecated_option "with-check" => "with-test"
  option "with-test", "Perform comprehensive tests (very slow w/out OpenMP)"

  option "with-openmp", "Build with OpenMP support"
  needs :openmp if build.with? "openmp"
  needs :cxx11 if build.with?("adol-c") || build.with?("ipopt")

  # Only one of --with-boost, --with-eigen and --with-std should be given.
  option "with-std", "Use std test vector"
  depends_on "boost" => :optional
  depends_on "eigen" => :optional

  depends_on "adol-c" => :optional
  depends_on "ipopt" => :optional
  depends_on "cmake" => :build

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
                  "-Dcmake_install_docdir=#{doc}"]

    cppad_testvector = "cppad"
    if build.with? "boost"
      cppad_testvector = "boost"
    elsif build.with? "eigen"
      cppad_testvector = "eigen"
      cmake_args << "-Deigen_prefix=#{Formula["eigen"].opt_prefix}"
      cmake_args << "-Dcppad_cxx_flags=-I#{Formula["eigen"].opt_include}/eigen3"
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
    cxx_compile = ENV.cxx.split + ["-c", "#{pkgshare}/example/acos.cpp", "-I#{opt_include}"]
    cxx_build = ENV.cxx.split + ["test.cpp", "-o", "test", "acos.o"]
    cd testpath do
      system *cxx_compile
      system *cxx_build
      system "./test"
    end
  end
end
