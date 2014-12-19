class Openblas < Formula
  homepage "http://www.openblas.net/"
  url "https://github.com/xianyi/OpenBLAS/archive/v0.2.13.tar.gz"
  sha1 "d41df33c902322a596cb1354393ddec633b958ab"
  head "https://github.com/xianyi/OpenBLAS.git", :branch => "develop"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "6c88c2ccc2170546b67e842d69b60a9efdce8eb7" => :yosemite
    sha1 "1f894d3979e10be8d20fb9a4ff55e342f224167f" => :mavericks
    sha1 "211c441c67c440e400c6b6e18dfb373dd5c0601b" => :mountain_lion
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
