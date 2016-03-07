class Cppad < Formula
  desc "Differentiation of C++ Algorithms"
  homepage "http://www.coin-or.org/CppAD"
  url "http://www.coin-or.org/download/source/CppAD/cppad-20150000.2.epl.tgz"
  version "20150000"
  sha256 "972498b307aff88173c4616e8e57bd2d1360d929a5faf49e3611910a182376f7"
  revision 1

  head "https://github.com/coin-or/CppAD.git"

  bottle do
    cellar :any
    sha256 "1ab8945781c80ad2ee3ab5a8de35fa27d16b81b612df382c144a4dd3a41a0dc6" => :yosemite
    sha256 "5042f10cc11838498d3663b8375b4124c2fcc07f9a6675e69fa96ed30f4a8d63" => :mavericks
    sha256 "17aeb9710856cb62a31f2b235a3ac78fd6bb79d96568bc9a2190292bb55da490" => :mountain_lion
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
