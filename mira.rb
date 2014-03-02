require 'formula'

class Mira < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/mira-assembler/'
  url 'https://downloads.sourceforge.net/project/mira-assembler/MIRA/stable/mira-3.4.1.1.tar.gz'
  sha1 '86bcf87f88296df4c3cce1d871e99a5bc3ca1dfd'

  depends_on 'boost'
  depends_on 'google-perftools'
  depends_on 'docbook'
  # On Xcode-only systems, Mira's configure is unable to find expat
  depends_on 'expat'
  # FlexLexer.h is not in the 10.8 SDK (only in 10.7 SDK and in xctoolchain/usr/include)
  # Further, an ugly patch would be needed to work with OS X's flex (on 10.8)
  # http://www.freelists.org/post/mira_talk/Type-mismatch-of-LexerInput-and-LexerOutput-PATCH
  depends_on 'flex'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-expat=#{Formula["expat"].opt_prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}"
    # Link with boost_system for boost::system::system_category().
    # http://www.freelists.org/post/mira_talk/Linking-requires-boost-system
    system "make LIBS=-lboost_system-mt install"
  end

  def test
    system "#{bin}/mira 2>&1 |grep -q MIRA"
  end
end
