class Trf < Formula
  homepage "http://tandem.bu.edu/trf/trf.html"
  # doi '10.1093/nar/27.2.573'
  version "4.07b"

  if OS.mac?
    url "http://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=29"
    sha256 "385ef13d0fcf53532fc0bdfe386c6789323a144b95c0e4b42c54b382bc5a7672"
  elsif OS.linux?
    url "http://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=26"
    sha1 "b4f24766f27f3b5f02957fa565da3bd114c37f9a"
  else
    raise "Unknown operating system"
  end

  def install
    bin.install "trf.download.pl" => "trf"
  end

  test do
    system "trf 2>&1 |grep -q trf"
  end
end
