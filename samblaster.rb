class Samblaster < Formula
  homepage "https://github.com/GregoryFaust/samblaster"
  #doi "10.1093/bioinformatics/btu314"
  #tag "bioinformatics"

  url "https://github.com/GregoryFaust/samblaster/releases/download/v.0.1.21/samblaster-v.0.1.21.tar.gz"
  sha1 "69514701966b1876af24ee09d4b4dd5a1622af86"
  head "https://github.com/GregoryFaust/samblaster"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "338892f077e9f8ba22e80bcf2b717e6ffe434bcb" => :yosemite
    sha1 "d5f499faef2d4577272845790f94a199b203da8e" => :mavericks
    sha1 "fee423532b377f1149f9accdd49d6b2255849285" => :mountain_lion
  end

  def install
    system "make"
    bin.install "samblaster"
  end

  test do
    system "#{bin}/samblaster", "--version"
  end
end
