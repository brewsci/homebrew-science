require 'formula'

class RmlMmc < Formula
  homepage 'http://www.ida.liu.se/labs/pelab/rml'
  url 'http://build.openmodelica.org/apt/pool/contrib/rml-mmc_255.orig.tar.gz'
  version '2.5.5'
  sha1 'ab173438a56f344904f6d02ccc8d6a360896219d'

  # Attention, has a self-signed certificate and svn will prompt you, so
  # do not use --HEAD as a dependency or automatic installation (built-bot).
  head 'https://openmodelica.org/svn/MetaModelica/trunk', :using => :svn

  depends_on 'smlnj'

  def install
    ENV.j1
    ENV['SMLNJ_HOME'] = Formula.factory("smlnj").prefix/'SMLNJ_HOME'

    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/rml", "-v"
  end
end
