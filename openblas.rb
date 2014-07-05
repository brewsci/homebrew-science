require 'formula'

class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.9.tar.gz"
  sha1 "e8197711c4fe43ac286366693bd7c1683003c894"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  devel do
    url "https://github.com/xianyi/OpenBLAS/archive/v0.2.10.rc2.tar.gz"
    sha1 "be0610c508e4105fa9ba31d8b0d421df9d634b41"
    version "0.2.10-rc2"
  end

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
