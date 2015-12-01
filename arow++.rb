class Arowxx < Formula
  homepage "https://code.google.com/p/arowpp/"
  url "https://arowpp.googlecode.com/files/AROW%2B%2B-0.1.2.tar.gz"
  sha256 "cd1637278503d1cc331c9225c4d2472f59bc5f9f9f7031133b484a37b139b344"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
