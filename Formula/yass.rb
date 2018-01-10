class Yass < Formula
  desc "YASS genomic similarity search tool"
  homepage "http://bioinfo.lifl.fr/yass/"
  url "http://bioinfo.lifl.fr/yass/files/yass-current/yass-1.14.tar.gz"
  sha256 "2ea4d2a32bb17fb6de590b0e8bce5231e2506b490b3456700b4bc029544a1982"

  bottle do
    cellar :any
    sha256 "6589335d6d86add715676f45dab2feaff1aa90e792938fa6a492a79e46df03da" => :yosemite
    sha256 "a92af72ef67cf58a6676b21bcfdcdad3a0fd32a4a4ca0f0c713db6b907f24846" => :mavericks
    sha256 "143badcfc331585a9aa682a1f00c411ca42d0ebe89e8ffb3063b430419f927b2" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "yass"
  end
end
