require "formula"

class Last < Formula
  homepage "http://last.cbrc.jp/"
  #doi "10.1101/gr.113985.110"
  url "http://last.cbrc.jp/last-418.zip"
  sha1 "fe1129a72df3907206d6b7375a96197137330c72"
  head "http://last.cbrc.jp/last", :using => :hg

  def install
    system "make", "install", "prefix=#{prefix}"
    doc.install Dir['*.txt', 'doc/*'], 'examples'
  end

  test do
    system "#{bin}/lastal -help"
  end
end
