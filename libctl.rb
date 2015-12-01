class Libctl < Formula
  homepage "http://ab-initio.mit.edu/wiki/index.php/Libctl"
  url "http://ab-initio.mit.edu/libctl/libctl-3.2.2.tar.gz"
  sha256 "8abd8b58bc60e84e16d25b56f71020e0cb24d75b28bc5db86d50028197c7efbc"

  depends_on "guile"
  depends_on :fortran

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
