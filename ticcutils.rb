class Ticcutils < Formula
  homepage "http://ilk.uvt.nl/ticcutils/"
  url "http://software.ticc.uvt.nl/ticcutils-0.7.tar.gz"
  sha256 "8a72b78da8f69fb09b83f032dffffc636a985fe266c9e8aca6d2a69ba49ec4f9"

  bottle do
    cellar :any
    sha1 "5e8c69c62810db58504dd2fd60c4d4d39929d87f" => :yosemite
    sha1 "307d320bb730deeaf83d452619e043d0ac0bde88" => :mavericks
    sha1 "336da8cc03521e25d220b56f722f6e7a4a8ab303" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

