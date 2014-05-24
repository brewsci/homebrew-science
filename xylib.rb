require "formula"

class Xylib < Formula
  homepage "http://xylib.sourceforge.net"
  url "https://github.com/wojdyr/xylib/releases/download/v1.3/xylib-1.3.tar.bz2"
  sha1 "61d95a9d3c98239fd4fb335fadadd85be3001a89"

  depends_on "boost" => :build
  depends_on "zlib" => :recommended

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xyconv", "--version"
    (testpath/'with_sigma.txt').write('20.0 490.5')
    system "#{bin}/xyconv", "-g", "#{testpath}/with_sigma.txt"
  end
end
