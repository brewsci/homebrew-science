class Stringtie < Formula
  desc "Transcript assembly and quantification for RNA-Seq"
  homepage "http://ccb.jhu.edu/software/stringtie"
  url "http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.0.tar.gz"
  sha256 "3a21c662904cdab0c749d5c3f5ef988e84fa036857ce2ca35782b3c19469c652"
  head "https://github.com/gpertea/stringtie.git"

  # doi "10.1038/nbt.3122"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "788b2bcaafc940f0cdf2d0d9635d23583df503ee3ee12339b3f8fccc27657958" => :el_capitan
    sha256 "0bfc0a7a768725ba881164e02ae92e47edaa0c723c18692d12d55b1bf2e1abe3" => :yosemite
    sha256 "3c86dba477c09224e6e47795d97a7fda71753a7335bf87f8134bff3501179d6f" => :mavericks
    sha256 "4141b1a98891c33c23a0aa961a9039e569496e369991a7d363f724bac5c034ca" => :x86_64_linux
  end

  def install
    system "make", "release"
    bin.install "stringtie"
    doc.install "README", "LICENSE"
  end

  test do
    assert_match "transcripts", shell_output("stringtie 2>&1", 1)
  end
end
