class Xfig < Formula
  desc "Interactive drawing tool for the X Window System"
  homepage "https://mcj.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcj/xfig-3.2.6a.tar.xz"
  sha256 "a87aeb5d424aadb84ede137291bbe8649551209a807c94f0956fc323b819267c"

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
