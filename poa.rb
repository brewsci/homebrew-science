class Poa < Formula
  homepage "https://sourceforge.net/projects/poamsa/"
  # doi "10.1093/bioinformatics/18.3.452"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/poamsa/poamsa/2.0/poaV2.tar.gz"
  version "2.0"
  sha1 "57f863956736498dd76afb57967036bf92c6d599"

  bottle do
    cellar :any
    sha1 "643d2c97e36be8aa642a79b563002ad6d9b2cd74" => :yosemite
    sha1 "f1f29b9d54318446a3bbbadd972c89ef8cd6b12d" => :mavericks
    sha1 "89d25fa0a1ab728e82afdcd69d0a70fc42526893" => :mountain_lion
  end

  def install
    system "make", "poa"
    bin.install "poa", "make_pscores.pl"
    doc.install "README"
    lib.install "liblpo.a"
    prefix.install "blosum80.mat", "blosum80_trunc.mat", "multidom.pscore", "multidom.seq"
    (include/"poa").install Dir["*.h"]
  end

  test do
    assert_match "poa", shell_output("#{bin}/poa 2>&1", 255)
  end
end
