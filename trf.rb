require 'formula'

class Trf < Formula
  homepage 'http://tandem.bu.edu/trf/trf.html'
  version '4.07b'

  if OS.mac?
    url 'http://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=29'
    sha1 'f25531945eb072aa2176f56222f2f26a3a82d0b0'
  elsif OS.linux?
    url 'http://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=26'
    sha1 'b4f24766f27f3b5f02957fa565da3bd114c37f9a'
  else
    raise 'Unknown operating system'
  end

  def install
    bin.install 'trf.download.pl' => 'trf'
  end

  test do
    system 'trf 2>&1 |grep -q trf'
  end
end
