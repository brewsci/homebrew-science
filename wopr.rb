class Wopr < Formula
  homepage "http://ilk.uvt.nl/wopr"
  url "http://software.ticc.uvt.nl/wopr-1.34.2.tar.gz"
  sha256 "bc271bcdd92bf28809e0f2e7ef47b739ff69f47c6b974222741b7682250d07be"

  depends_on "pkg-config" => :build
  depends_on "timbl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
