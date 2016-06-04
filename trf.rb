class Trf < Formula
  desc "Tandem repeats finder"
  homepage "http://tandem.bu.edu/trf/trf.html"
  # doi '10.1093/nar/27.2.573'
  # tag "bioinformatics"
  version "4.07b"

  if OS.mac?
    url "http://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=29"
    sha256 "385ef13d0fcf53532fc0bdfe386c6789323a144b95c0e4b42c54b382bc5a7672"
  elsif OS.linux?
    url "http://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=26"
    sha256 "a3a760c7b74c9603fbc08d95e8fa696c00f35a2f179b0bd63b2b13757ad3b471"
  else
    raise "Unknown operating system"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "83f9ac163d4d16194dbcfaf9d7167a7ddac4175f2d30b07d442bbf1133b3ae2c" => :el_capitan
    sha256 "5b0f7c05afa414b25f10a0780cad5a8f088a1b6d75b256344201c1776627396b" => :yosemite
    sha256 "e418c532b280de9321bef4b8fec4561c6a6425050a8b9114d7a42eebbd348e7e" => :mavericks
    sha256 "ee6cb93b8514c0bfe411a93024d378f6ab3c88ff0c431e6d3f0a37d27df74802" => :x86_64_linux
  end

  def install
    bin.install "trf.download.pl" => "trf"
  end

  test do
    assert_match "Tandem Repeats Finder", shell_output("#{bin}/trf 2>&1", 255)
  end
end
