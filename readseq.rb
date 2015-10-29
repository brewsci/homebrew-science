class Readseq < Formula
  desc "Read and reformat biosequences"
  homepage "http://iubio.bio.indiana.edu/soft/molbio/readseq/java/"
  # tag "bioinformatics"

  url "http://iubio.bio.indiana.edu/soft/molbio/readseq/java/readseq.jar"
  version "2.1.30"
  sha256 "830c79f5eba44c8862a30a03107fe65ad044b6b099b75f9638d7482e0375aab6"

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
