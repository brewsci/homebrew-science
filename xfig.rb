class Xfig < Formula
  desc "Interactive drawing tool for the X Window System"
  homepage "https://mcj.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcj/xfig-3.2.6a.tar.xz"
  sha256 "a87aeb5d424aadb84ede137291bbe8649551209a807c94f0956fc323b819267c"
  revision 1

  bottle do
    sha256 "44530539a62a89c10d0177ee6eb1d53b8976d057a7332a7cb8bcbd51fccb734f" => :sierra
    sha256 "d92b550f13dfb298980cd4f67f2f37a6259c1eb14648f08963052c7913819b48" => :el_capitan
    sha256 "0631ad0780ebb845a238af534fff46b286213771570596bd7695bc725bf8b96a" => :yosemite
  end

  depends_on :x11
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "ghostscript"

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
