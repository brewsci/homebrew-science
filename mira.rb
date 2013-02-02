require 'formula'

class Mira < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/mira-assembler/'
  url 'http://downloads.sourceforge.net/project/mira-assembler/MIRA/stable/mira-3.4.1.1.tar.gz'
  sha1 '86bcf87f88296df4c3cce1d871e99a5bc3ca1dfd'

  depends_on 'boost'
  depends_on 'google-perftools'
  depends_on 'docbook'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    # Link with boost_system for boost::system::system_category().
    # http://www.freelists.org/post/mira_talk/Linking-requires-boost-system
    system "make LIBS=-lboost_system-mt install"
  end

  def test
    system "#{bin}/mira 2>&1 |grep -q MIRA"
  end
end
