class Express < Formula
  homepage "http://bio.math.berkeley.edu/eXpress/"
  head "https://github.com/adarob/eXpress.git"
  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "1ab122db4fa3af3e8e9d93e49702c1a1aa75a249" => :yosemite
    sha1 "3e17818affce1700e88a1d0934be13d76e4241ae" => :mavericks
    sha1 "6d648767ea1dd5fc3eb45ded0389b8c9eb4ad8b3" => :mountain_lion
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
