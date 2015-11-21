class Ticcutils < Formula
  desc "Tools for the TiCC Software Stack"
  homepage "http://ilk.uvt.nl/ticcutils/"
  url "http://software.ticc.uvt.nl/ticcutils-0.7.tar.gz"
  sha256 "8a72b78da8f69fb09b83f032dffffc636a985fe266c9e8aca6d2a69ba49ec4f9"
  revision 1

  bottle do
    cellar :any
    sha256 "ab116db5f7cc8455f1c5d9bd0034577d6eccd9f9133ba418e4a21c6cb795242f" => :el_capitan
    sha256 "1c71bee71cf797698a4df8f1041a02f7e8e20af3dda77efedc0c4cf6790b21c3" => :yosemite
    sha256 "eea831350727ba0a45381dba98aaae0afea8777c56cb144f52e10c5f3ed85842" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
