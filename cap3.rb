require 'formula'

class Cap3 < Formula
  homepage 'http://seq.cs.iastate.edu/cap3.html'
  if OS.mac? then
    url 'http://seq.cs.iastate.edu/CAP3/cap3.macosx.intel64.tar'
    sha1 '42606cea94a70bcbcb128fe7d427c35a7ebc5f19'
  elsif OS.linux? then
    url 'http://seq.cs.iastate.edu/CAP3/cap3.linux.x86_64.tar'
    sha1 'c2c4433a692a51e5619a363f1105b7e36afc51b6'
  end
  version '2007-12-21'

  def install
    bin.install 'cap3', 'formcon'
    doc.install %w[README aceform doc example]
  end

  test do
    system 'cap3 2>&1 |grep -q cap3'
  end
end
