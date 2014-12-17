class Express < Formula
  homepage "http://bio.math.berkeley.edu/eXpress/"
  head "https://github.com/adarob/eXpress.git"
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
