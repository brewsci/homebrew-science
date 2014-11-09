require "formula"

class Libctl < Formula
  homepage "http://ab-initio.mit.edu/wiki/index.php/Libctl"
  url "http://ab-initio.mit.edu/libctl/libctl-3.2.2.tar.gz"
  sha1 "d7f860313d5cc226c51f868bbe9bb930d143ab9c"

  depends_on "guile"
  depends_on :fortran

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
