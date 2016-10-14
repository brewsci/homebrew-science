class TmvCpp < Formula
  desc "user-friendly C++ interface to BLAS and LAPACK"
  homepage "https://github.com/rmjarvis/tmv"
  url "https://github.com/rmjarvis/tmv/archive/v0.73.tar.gz"
  sha256 "6b44b89e14b9b6041af0b080ff122a5480876fdd5e5a65eaeb93ec1c98ffc582"
  head "https://github.com/rmjarvis/tmv.git"

  bottle do
    cellar :any
    sha256 "c22c4a27e0f18927b85f8e0454b51c92d1ab636bef713cb8c6771c4e6d98286b" => :sierra
    sha256 "f555a81859663a4ba960369bb737642b19c2aff9bd182dace56782ee53647e63" => :el_capitan
    sha256 "c267898309507b441d89163f69795ca67de36e165f6baa0651253820366f441c" => :yosemite
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

    # dylibs don't have the correct install name.
    %w[libtmv.0.dylib libtmv_symband.0.dylib].each do |libname|
      system "install_name_tool", "-id", "#{lib}/#{libname}", "#{lib}/#{libname}"
    end

    (pkgshare/"tests").install Dir["test/tmvtest*"] if build.with? "test"
    (pkgshare/"examples").install Dir["examples/*[^\.o]"]
  end

  test do
    Dir[pkgshare/"tests/tmvtest*"].each do |testcase|
      system testcase
    end
  end
end
