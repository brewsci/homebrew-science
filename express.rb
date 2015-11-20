class Express < Formula
  homepage "http://bio.math.berkeley.edu/eXpress/"
  head "https://github.com/adarob/eXpress.git"
  bottle do
    cellar :any
    sha256 "d30e4483050d6994866db4e3666db2d0835768ef01d606f39cd18cc776e2f6e2" => :yosemite
    sha256 "e3936ddbf9cf14fbdb9654bf7b1fe92d0fd05452ab50b16e462a5a70c5704b47" => :mavericks
    sha256 "139f8bd643e922f7703d032d27925a049dda3b926c715ac371989e519d047af8" => :mountain_lion
  end

  #doi "10.1038/nmeth.2251"
  #tag "bioinformatics"

  url "http://bio.math.berkeley.edu/eXpress/downloads/express-1.5.1/express-1.5.1-src.tgz"
  sha1 "173f5b340f69d50096271a0199716d0acbbaf446"

  depends_on "bamtools"
  depends_on "boost"
  depends_on "cmake" => :build

  def install
    mkdir "bamtools"
    ln_s Formula["bamtools"].include/"bamtools", "bamtools/include"
    ln_s Formula["bamtools"].lib, "bamtools/"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/express 2>&1 |grep express"
  end
end
