require 'formula'

class CeresSolver < Formula
  homepage 'http://code.google.com/p/ceres-solver/'
  url 'http://ceres-solver.googlecode.com/files/ceres-solver-1.5.0.tar.gz'
  sha1 '68851761f5af9f8bd872ca97726c8871c38975d0'

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
