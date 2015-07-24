class Readseq < Formula
  homepage "https://sourceforge.net/projects/readseq/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/readseq/readseq/2.1.19/readseq.jar"
  sha256 "966e7d4e1c4c6add588b3ead281c993c6a0c35b991a1ded53f81230a54ac6778"
  version "2.1.19"

  bottle do
    cellar :any
    sha256 "7994212c962f257a42b219e2e2093e99afb3c72bec99789cf1190b8cae415e66" => :yosemite
    sha256 "2270a6f76d5dd12b4acff49385861d3c5067aba7b7728d0339caf39a1bf992b0" => :mavericks
    sha256 "2012c2bc28373062fbad6d5b607ff395915a9af25684d689442b1d3ccb37991a" => :mountain_lion
  end

  depends_on :java

  def install
    jar = "readseq.jar"
    java = share/"java"
    java.install jar
    bin.write_jar_script java/jar, "readseq"
  end

  test do
    system "#{bin}/readseq"
  end
end
