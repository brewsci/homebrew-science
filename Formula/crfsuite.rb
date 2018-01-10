class Crfsuite < Formula
  homepage "http://www.chokkan.org/software/crfsuite"
  url "https://github.com/downloads/chokkan/crfsuite/crfsuite-0.12.tar.gz"
  sha256 "e7fc2d88353b1f4de799245f777d90f3c89a9d9744ba9fbde8c7553fa78a1ea1"

  depends_on "liblbfgs"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
