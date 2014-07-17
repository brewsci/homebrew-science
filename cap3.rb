require 'formula'

class Cap3 < Formula
  homepage 'http://seq.cs.iastate.edu/cap3.html'
  if OS.mac? then
    url 'http://seq.cs.iastate.edu/CAP3/cap3.macosx.intel64.tar'
    sha1 '42606cea94a70bcbcb128fe7d427c35a7ebc5f19'
  elsif OS.linux? then
    url 'http://seq.cs.iastate.edu/CAP3/cap3.linux.x86_64.tar'
    sha1 'c062ff742abb422f25f6e7db76482694b34dab8f'
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
