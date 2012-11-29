require 'formula'

class Amos < Formula
  homepage 'http://sourceforge.net/apps/mediawiki/amos/index.php?title=AMOS'
  url 'http://sourceforge.net/projects/amos/files/amos/3.1.0/amos-3.1.0.tar.gz'
  sha1 '28e799e37713594ba7147d300ecae6574beb14a4'

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Perl modules have been placed in
      #{lib}
    EOS
  end
end
