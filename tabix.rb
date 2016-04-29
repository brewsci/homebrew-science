class Tabix < Formula
  desc "Generic indexer for TAB-delimited genome position files"
  homepage "http://samtools.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/samtools/tabix/tabix-0.2.6.tar.bz2"
  sha256 "e4066be7101bae83bec62bc2bc6917013f6c2875b66eb5055fbb013488d68b73"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "d04eb6c12677d4c4936ab5cd509d66e69e94281810d67ad0cb268c6a08e574df" => :el_capitan
    sha256 "b9759edcaf0c818e74f863a1a49e5180b454c5f3b22f887d19f4c8fce0b08518" => :yosemite
    sha256 "438203b1e297de28a5c270f4815b669cd0eebb96113b337080efe8ca77bc6b69" => :mavericks
  end

  head "https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/tabix"

  conflicts_with "htslib",
    :because => "tabix and bgzip binaries are now part of the HTSlib project"

  def install
    system "make"
    bin.install %w[tabix bgzip]
    man1.install "tabix.1"
    ln_s man1+"tabix.1", man1+"bgzip.1"
  end
end
