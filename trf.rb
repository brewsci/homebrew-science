class Trf < Formula
  desc "Tandem repeats finder"
  homepage "https://tandem.bu.edu/trf/trf.html"
  # doi '10.1093/nar/27.2.573'
  # tag "bioinformatics"
  version "4.07b"

  if OS.mac?
    url "https://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=29"
    sha256 "385ef13d0fcf53532fc0bdfe386c6789323a144b95c0e4b42c54b382bc5a7672"
  elsif OS.linux?
    url "https://tandem.bu.edu/cgi-bin/trf/trf.download.pl?fileselect=26"
    sha256 "a3a760c7b74c9603fbc08d95e8fa696c00f35a2f179b0bd63b2b13757ad3b471"
  else
    raise "Unknown operating system"
  end

  # The license does not permit redistribution. http://tandem.bu.edu/trf/trf.license.html
  bottle :unneeded

  def install
    bin.install "trf.download.pl" => "trf"
  end

  test do
    assert_match "Tandem Repeats Finder", shell_output("#{bin}/trf 2>&1", 255)
  end
end
