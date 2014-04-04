require 'formula'

class Openblas < Formula
  homepage 'http://xianyi.github.io/OpenBLAS/'
  url 'https://github.com/xianyi/OpenBLAS/archive/v0.2.9.rc2.tar.gz'
  sha1 '60fbd30e94bb37e510fddd46bcfadfdb44cfff8c'
  version '0.2.9-rc2'
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
