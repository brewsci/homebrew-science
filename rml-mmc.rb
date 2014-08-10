require 'formula'

class RmlMmc < Formula
  homepage 'http://www.ida.liu.se/labs/pelab/rml'
  url "http://build.openmodelica.org/apt/pool/contrib/rml-mmc_274.orig.tar.gz"
  version "274"
  sha1 "d6fa3ad52dbf0f4606acd727bf0ed58d6c3cc88f"

  # Attention, has a self-signed certificate and svn will prompt you, so
  # do not use --HEAD as a dependency or automatic installation (built-bot).
  head 'https://openmodelica.org/svn/MetaModelica/trunk', :using => :svn

  depends_on 'smlnj'

  def install
    ENV.j1
    ENV['SMLNJ_HOME'] = Formula["smlnj"].opt_prefix/'SMLNJ_HOME'

    system "./configure --prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/rml", "-v"
  end
end
