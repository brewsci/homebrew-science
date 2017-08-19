class Ticcutils < Formula
  desc "Tools for the TiCC Software Stack"
  homepage "https://ilk.uvt.nl/ticcutils/"
  url "https://github.com/LanguageMachines/ticcutils/releases/download/v0.15/ticcutils-0.15.tar.gz"
  sha256 "424413e8f49e403edef61d82baf4e885e9d000fab78d774ff5cac6d9831ab630"

  bottle do
    cellar :any
    sha256 "ab116db5f7cc8455f1c5d9bd0034577d6eccd9f9133ba418e4a21c6cb795242f" => :el_capitan
    sha256 "1c71bee71cf797698a4df8f1041a02f7e8e20af3dda77efedc0c4cf6790b21c3" => :yosemite
    sha256 "eea831350727ba0a45381dba98aaae0afea8777c56cb144f52e10c5f3ed85842" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libxml2" unless OS.mac?

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
