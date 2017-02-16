class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "https://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.3.tar.gz"
  sha256 "c01b16a681dc55f114dbfc2fcd725f615b2d9a79058ff8c110047cfa9cbe2976"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "9244ffbf95592cee071e659f11effaffc514812f9f38b97ba62f7b2c2891f3b6" => :sierra
    sha256 "1babb96c5541ad62dfd0dde657a9000817df6caef7a198885904fe7d4726ed6b" => :el_capitan
    sha256 "6ef20717d38394466a4b594a9c9466a984fa4452189a4782c9c75309facc5e60" => :yosemite
    sha256 "525658d8a6e69a25b7071611ecd55ef03274e731f97d4003985e0b55aa19cf5a" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
  end

  test do
    assert_match "transcripts", shell_output("#{bin}/stringtie 2>&1", 1)
  end
end
