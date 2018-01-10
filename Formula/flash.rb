class Flash < Formula
  desc "Merge mates from overlapping fragments"
  homepage "https://ccb.jhu.edu/software/FLASH/"
  # doi "10.1093/bioinformatics/btr507"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/flashpage/FLASH-1.2.11.tar.gz"
  sha256 "685ca6f7fedda07434d8ee03c536f4763385671c4509c5bb48beb3055fd236ac"

  bottle do
    cellar :any
    sha256 "206839e1465012091e27ec4c3c35f8872f35602b24e28d5883d59f56ab9640f8" => :yosemite
    sha256 "888410d1c714b4cd7d26231774b0cfc767bf2c89e1ecd719f5252de1e1a90c34" => :mavericks
    sha256 "21ea6e6967301f942336c7c9f45502786bbf7ee02ac5338fe6c02e4f65b1e429" => :mountain_lion
    sha256 "12342a056b7ee5c94780422d21e35056d991ac162e87b5331c759504a3ddadbb" => :x86_64_linux
  end

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
