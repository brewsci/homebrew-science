class Flash < Formula
  homepage "http://ccb.jhu.edu/software/FLASH/"
  # doi "10.1093/bioinformatics/btr507"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/flashpage/FLASH-1.2.11.tar.gz"
  sha256 "685ca6f7fedda07434d8ee03c536f4763385671c4509c5bb48beb3055fd236ac"

  def install
    system "make"
    bin.install "flash"
    doc.install "README", "NEWS", "COPYING"
  end

  test do
    assert_match "MATES", shell_output("flash 2>&1", 2)
    assert_match "threads", shell_output("flash --help 2>&1", 0)
  end
end
