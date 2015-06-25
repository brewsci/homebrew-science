class Samblaster < Formula
  desc "Tool to mark duplicates in SAM files"
  homepage "https://github.com/GregoryFaust/samblaster"
  # doi "10.1093/bioinformatics/btu314"
  # tag "bioinformatics"

  url "https://github.com/GregoryFaust/samblaster/archive/v.0.1.22.tar.gz"
  sha256 "829f6036cf081a2a64716bbb1940d4b5fef96979adfee8650c1ffe4ce6f46c8b"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "01da597dca44539d4c8218f6320c1d333cbbf9f4" => :yosemite
    sha1 "17c2c763ff473604a5f0e492980c562222a83708" => :mavericks
    sha1 "16eb49671b88fb0ddc9730f7f3bb3ccd76231c52" => :mountain_lion
  end

  def install
    system "make"
    bin.install "samblaster"
  end

  test do
    system "#{bin}/samblaster", "--version"
  end
end
