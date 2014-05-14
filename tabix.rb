require 'formula'

class Tabix < Formula
  homepage 'http://samtools.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/samtools/tabix/tabix-0.2.6.tar.bz2'
  sha1 '4f0cac0da585abddc222956cac1b6e508ca1c49e'

  head 'https://samtools.svn.sourceforge.net/svnroot/samtools/trunk/tabix'

  conflicts_with "htslib",
    :because => "tabix and bgzip binaries are now part of the HTSlib project"

  def install
    system "make"
    bin.install %w{tabix bgzip}
    man1.install 'tabix.1'
    ln_s man1+'tabix.1', man1+'bgzip.1'
  end
end
