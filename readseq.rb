class Readseq < Formula
  desc "Read and reformat biosequences"
  homepage "http://iubio.bio.indiana.edu/soft/molbio/readseq/java/"
  # tag "bioinformatics"

  url "http://iubio.bio.indiana.edu/soft/molbio/readseq/java/readseq.jar"
  version "2.1.30"
  sha256 "830c79f5eba44c8862a30a03107fe65ad044b6b099b75f9638d7482e0375aab6"

  bottle do
    cellar :any_skip_relocation
    sha256 "3049186a14314a6fb0ef7f43d5dfa95cfedded12c6070a9f13b78e5243d1a054" => :el_capitan
    sha256 "cad85b8754b8422b12583618e4aa125c60a6cd42243cd3d59c6e0000eb087bd4" => :yosemite
    sha256 "c3bf88928d04dd264e2987b20f2b9a66e1a7e74d9a5dad123354f1865ae57c01" => :mavericks
    sha256 "488c00596fc31eb169b6ffc6e6a5d0796445135b04828ae167ac6c33e265066f" => :x86_64_linux
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
