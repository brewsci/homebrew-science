require 'formula'

class Amos < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS'
  url 'https://downloads.sourceforge.net/project/amos/amos/3.1.0/amos-3.1.0.tar.gz'
  sha1 '28e799e37713594ba7147d300ecae6574beb14a4'

  depends_on 'blat' => :optional # for minimus2-blat
  depends_on 'boost' => :recommended # for Bambus 2
  depends_on 'mummer' => :recommended # for minimus2
  depends_on 'qt' => [:optional, 'with-qt3support'] # for AMOS GUIs
  depends_on 'Statistics::Descriptive' => [:perl, :recommended]

  fails_with :clang do
    build 500
    cause "error: reference to 'hash' is ambiguous"
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
      "--with-Boost-dir=#{Formula["boost"].opt_prefix}",
      "--with-qmake-qt4=#{Formula["qt"].opt_prefix}/bin/qmake",
      "BLAT=#{Formula["blat"].opt_prefix}/bin/blat",
      "DELTAFILTER=#{Formula["mummer"].opt_prefix}/libexec/delta-filter",
      "SHOWCOORDS=#{Formula["mummer"].opt_prefix}/libexec/show-coords"
    system "make install"
  end

  def caveats; <<-EOS.undent
    The Perl modules have been installed in
      #{lib}/AMOS
      #{lib}/TIGR
    EOS
  end

  def test
    system "#{bin}/bank-transact -h"
  end
end
