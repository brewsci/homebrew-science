class Liblbfgs < Formula
  homepage "http://www.chokkan.org/software/liblbfgs"
  url "https://github.com/downloads/chokkan/liblbfgs/liblbfgs-1.10.tar.gz"
  sha256 "4158ab7402b573e5c69d5f6b03c973047a91e16ca5737d3347e3af9c906868cf"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
