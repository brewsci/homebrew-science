require 'formula'

class CeresSolver < Formula
  homepage 'http://code.google.com/p/ceres-solver/'
  url 'http://ceres-solver.googlecode.com/files/ceres-solver-1.6.0.tar.gz'
  sha1 '0fdd7a931498bd09dc167827f4412c368f89bd25'
  head 'https://ceres-solver.googlesource.com/ceres-solver.git'

  depends_on 'cmake' => :build
  depends_on 'glog'
  depends_on 'gflags'
  depends_on 'eigen'
  depends_on 'suite-sparse' => :recommended
  depends_on 'protobuf' => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end
