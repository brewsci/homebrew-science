require 'formula'

class Qualimap < Formula
  homepage 'http://qualimap.bioinfo.cipf.es/'
  url 'https://bitbucket.org/kokonech/qualimap/downloads/qualimap-build-06-03-15.tar.gz'
  sha1 'fc0a227d2739a1e92b95cfabee074dc54d4c7ce6'
  version '06-03-15'
  depends_on 'r' => :optional

  def install
    inreplace 'qualimap', /-classpath [^ ]*/, "-classpath '#{libexec}/*'"
    bin.install 'qualimap'
    libexec.install 'scripts', 'species', 'qualimap.jar', *Dir['lib/*.jar']
    doc.install 'QualimapManual.pdf'
  end

  test do
    system 'qualimap', '-h'
  end
end
