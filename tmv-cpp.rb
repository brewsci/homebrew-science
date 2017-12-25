class TmvCpp < Formula
  desc "user-friendly C++ interface to BLAS and LAPACK"
  homepage "https://github.com/rmjarvis/tmv"
  url "https://github.com/rmjarvis/tmv/archive/v0.75.tar.gz"
  sha256 "f0ed1b500c5f4ee12f9d018a7d6a883f06df4a345a1010e3f96223410c9b3dea"
  head "https://github.com/rmjarvis/tmv.git"

  bottle do
    cellar :any
    sha256 "18d80d1ab60aa4edaa4ae2f1a5e0853b8710fc7ba71ec436cd7dc3daa201c99c" => :high_sierra
    sha256 "aaaea5f9d8ead80b0ab7fa18d73e7a932022cbb468de99b17dc226d2434133e3" => :sierra
    sha256 "0d1af7e8958e5334e8c149c93ef1ce8d3fd4503e28cb748e88d114efa756c504" => :el_capitan
    sha256 "d840dd1ac713697096c9d976b19b0337c0ce75411750c1e77328ff83ccb602a1" => :x86_64_linux
  end

  option "without-test", "Do not build tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  option "with-full-check", "Go through all tests (time consuming)"
  option "with-openmp", "Enable OpenMP multithreading"

  depends_on "scons" => :build

  # currently fails with g++-6
  # https://github.com/rmjarvis/tmv/issues/22
  needs :openmp if build.with? "openmp"

  def install
    args = ["CXX=#{ENV["CXX"]}", "PREFIX=#{prefix}"]
    args += %w[INST_FLOAT=true INST_DOUBLE=true INST_LONGDOUBLE=true
               INST_INT=true SHARED=true TEST_FLOAT=true TEST_DOUBLE=true
               TEST_INT=true TEST_LONGDOUBLE=true
               WITH_BLAS=true WITH_LAPACK=true]
    args << "XTEST=1111111" if build.with? "full-check"
    args << ("WITH_OPENMP=" + (build.with?("openmp") ? "true" : "false"))

    scons *args
    scons "tests" if build.with? "test"
    scons "examples"
    scons "install"

    (pkgshare/"tests").install Dir["test/tmvtest*"] if build.with? "test"
    (pkgshare/"examples").install Dir["examples/*[^\.o]"]
  end

  test do
    Dir[pkgshare/"tests/tmvtest*"].each do |testcase|
      system testcase
    end
  end
end
