require "formula"

class Aragorn < Formula
  homepage "http://mbio-serv2.mbioekol.lu.se/ARAGORN/"
  #doi "10.1093/nar/gkh152"

  url "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/aragorn1.2.36.tgz"
  sha1 "3fd5dafa5fa0a65c303d866fc4506bfbc38efbcb"

  def install
    mv "aragorn#{version}.c", "aragorn.c"
    system "make", "aragorn"
    bin.install "aragorn"
    man1.install "aragorn.1"
  end

  test do
    system "#{bin}/aragorn -h"
  end
end
