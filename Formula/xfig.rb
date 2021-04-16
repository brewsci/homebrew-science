class Xfig < Formula
  desc "Interactive drawing tool for the X Window System"
  homepage "https://mcj.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcj/xfig-3.2.6a.tar.xz"
  sha256 "a87aeb5d424aadb84ede137291bbe8649551209a807c94f0956fc323b819267c"
  revision 1

  bottle do
    root_url "https://archive.org/download/brewsci/bottles-science"
    sha256 sierra:     "964981e25d43fa075b88db9d9926b7bf1695a4967508f289527130c3187dfdff"
    sha256 el_capitan: "6b2b699c0ffd866f0bf44230d6867dc178ead9e21361f8fbebf9505ea017a7c1"
    sha256 yosemite:   "d075ab9a33cadba801f7e4b568e8dbca32ad30edd7bde8ab8139c7dfbe450080"
  end

  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libx11"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/xfig", "-v"
  end
end
