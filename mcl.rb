require "formula"

class Mcl < Formula
  homepage "http://micans.org/mcl"
  url "http://micans.org/mcl/src/mcl-14-137.tar.gz"
  version "14-137"
  sha1 "9016240ecdc39d26e493c1e18967e46ff0742bdd"

  def install
    bin.mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-blast"
    system "make install"
  end
end
