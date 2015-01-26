class Pear < Formula
  homepage "http://www.exelixis-lab.org/pear"
  # doi "10.1093/bioinformatics/btt593"
  # tag "bioinformatics"

  url "http://sco.h-its.org/exelixis/web/software/pear/files/pear-0.9.6-src.tar.gz"
  sha1 "351bde183653facb9c6a4e0b7a4328a130c3b903"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "03273d7ee8328f621c153db9694cfc777d259023" => :yosemite
    sha1 "216efd5def8ba3ad843bb0ccc290e7120a4a0605" => :mavericks
    sha1 "27393ec465f041f174b433fcfe60d41949b0eb2c" => :mountain_lion
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pear --help 2>&1 |grep -q pear"
  end
end
