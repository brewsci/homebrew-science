require 'formula'

class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.10.tar.gz"
  sha1 "c4a5ca4cb9876a90193f81a0c38f4abccdf2944d"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  depends_on :fortran

  # OS X provides the Accelerate.framework, which is a BLAS/LAPACK impl.
  keg_only :provided_by_osx

  def install
    # Must call in two steps
    system "make", "FC=#{ENV['FC']}", "libs", "netlib", "shared"
    system "make", "FC=#{ENV['FC']}", "tests"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
