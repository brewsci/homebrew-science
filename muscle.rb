class Muscle < Formula
  desc "Multiple sequence alignment program"
  homepage "http://www.drive5.com/muscle/"
  url "http://www.drive5.com/muscle/muscle_src_3.8.1551.tar.gz"
  sha256 "c70c552231cd3289f1bad51c9bd174804c18bb3adcf47f501afec7a68f9c482e"
  # doi "10.1093/nar/gkh340", "10.1186/1471-2105-5-113"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "095e948e36fbdcea5dce3aa55aa7a5aa76101d41e86306b15aa15f827c70eac3" => :el_capitan
    sha256 "2b4484979ad18f9cfaff6905925424666cdbb46972000cbd87155c24b27accd7" => :yosemite
    sha256 "c020974f146e0b5f35c16e79aa64c00b2cd06ea3ecd16d5f39e26c11318a2e45" => :mavericks
    sha256 "6bbc809f7436978ce1c7894b1bb266c77d2ccabdd9a702d991bb0bc0e798f352" => :x86_64_linux
  end

  def install
    # Fix build per Makefile instructions
    inreplace "Makefile", "-static", ""

    system "make"
    bin.install "muscle"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muscle -version")
  end
end
