require "formula"

class Cppad < Formula
  homepage "http://www.coin-or.org/CppAD"
  url "http://www.coin-or.org/download/source/CppAD/cppad-20141101.epl.tgz"
  version "20141101"
  sha1 "4f5971160c458d65dc751daa1ba6937514901714"
  head "https://github.com/bradbell/cppad.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "c3133a1a24f61366366f83675d1f49f8429014a4" => :yosemite
    sha1 "eb48a1b0a51bc5883a2bb4c430b09b3e9523debf" => :mavericks
    sha1 "850e597d558e05a95f38a57b75e0a94609ef160a" => :mountain_lion
  end

  # Only one of --with-boost, --with-eigen and --with-std should be given.
  depends_on "boost" => :optional
  depends_on "eigen" => :optional
  depends_on "adol-c" => :optional
  option "with-std", "Use std test vector"
  option "with-check", "Perform comprehensive tests (very slow w/out OpenMP)"

  depends_on "cmake" => :build
  depends_on "ipopt" => :optional

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
    ENV.cxx11 if build.with? "adol-c" or build.with? "ipopt"

    if ENV.compiler == :clang
      opoo "OpenMP support will not be enabled. Use --cc=gcc-x.y if you require OpenMP."
    end

    cmake_args = ["-Dcmake_install_prefix=#{prefix}",
                  "-Dcmake_install_docdir=#{share}/cppad/doc"]

    cppad_testvector = "cppad"
    if build.with? "boost"
      cppad_testvector = "boost"
    elsif build.with? "eigen"
      cppad_testvector = "eigen"
      cmake_args << "-Deigen_prefix=#{Formula['eigen'].opt_prefix}"
      cmake_args << "-Dcppad_cxx_flags=-I#{Formula['eigen'].opt_include}/eigen3"
    elsif build.with? "std"
      cppad_testvector = "std"
    end
    cmake_args << "-Dcppad_testvector=#{cppad_testvector}"

    if build.with? "adol-c"
      adolc_opts = Tab.for_name("adol-c").used_options
      cmake_args << "-Dadolc_prefix=#{Formula['adol-c'].opt_prefix}"
      cmake_args << "-Dcolpack_prefix=#{Formula['colpack'].opt_prefix}" unless adolc_opts.include? "without-colpack"
    end

    if build.with? "ipopt"
      cmake_args << "-Dipopt_prefix=#{Formula['ipopt'].opt_prefix}" if build.with? "ipopt"
      cmake_args << "-DCMAKE_EXE_LINKER_FLAGS=#{ENV.ldflags}" + ((ipopt_options.include? "with-openblas") ? "-L#{Formula['openblas']}.lib -lopenblas" : "-lblas")
      # For some reason, ENV.cxx11 isn"t sufficient when building with gcc.
      cmake_args << "-Dcppad_cxx_flags=-std=c++11" if ENV.compiler != :clang
    end

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make check" if build.with? "check"
      system "make install"
    end
  end
end
