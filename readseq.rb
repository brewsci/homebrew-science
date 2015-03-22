class Readseq < Formula
  homepage "https://sourceforge.net/projects/readseq/"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/readseq/readseq/2.1.19/readseq.jar"
  sha256 "966e7d4e1c4c6add588b3ead281c993c6a0c35b991a1ded53f81230a54ac6778"
  version "2.1.19"

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
