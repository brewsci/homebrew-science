require 'formula'

class CeresSolver < Formula
  homepage 'http://code.google.com/p/ceres-solver/'
  url 'http://ceres-solver.googlecode.com/files/ceres-solver-1.7.0.tar.gz'
  sha1 '412af6f267852554eae47d3bfe412607ee41c7c5'
  head 'https://ceres-solver.googlesource.com/ceres-solver.git'

  depends_on 'cmake' => :build
  depends_on 'glog'
  depends_on 'gflags'
  depends_on 'eigen'
  depends_on 'suite-sparse' => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end
