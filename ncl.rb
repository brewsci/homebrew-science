require "formula"

class Ncl < Formula
  homepage "http://ncl.sourceforge.net/"
  #doi "10.1093/bioinformatics/btg319"
  #tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/ncl/NCL/ncl-2.1.18/ncl-2.1.18.tar.gz"
  sha1 "54e4f1ff4fef52cfd633b467a839e57a2670a397"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"

    share.install "data", "example", "test"
  end

  test do
    cp "#{share}/data/sample.tre", "."
    system "#{bin}/NCLconverter", "sample.tre"
    assert File.exist?("out.xml")
  end
end
