require "formula"

class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.13.tar.gz"
  sha1 "d41df33c902322a596cb1354393ddec633b958ab"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"
  revision 1

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "76c513443a817460021884a75eb53cacb9c75c53" => :yosemite
    sha1 "301cfa90190768a5ff93bae40bf9e3704da6f460" => :mavericks
    sha1 "c1a879f01180bda6727b7817e3123b1849acc327" => :mountain_lion
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
