class Xylib < Formula
  desc "Library for reading x-y data files"
  homepage "http://xylib.sourceforge.net"
  url "https://github.com/wojdyr/xylib/releases/download/v1.3/xylib-1.3.tar.bz2"
  sha256 "7047bc6730bc61f7f0be94e8872414768a94a409dcc10059556dbc25b1114426"

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
    (testpath/"with_sigma.txt").write "20.0 490.5"
    system "#{bin}/xyconv", "-g", "#{testpath}/with_sigma.txt"
  end
end
