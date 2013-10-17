require 'formula'

class Qualimap < Formula
  homepage 'http://qualimap.bioinfo.cipf.es/'
  url 'http://qualimap.bioinfo.cipf.es/release/qualimap_v0.7.1.zip'
  sha1 '65be770802797998fa1a96fb3c12558b8b741052'

  depends_on 'r' => :optional

  def install
    inreplace 'qualimap', /-classpath [^ ]*/, "-classpath '#{libexec}/*'"
    bin.install 'qualimap'
    libexec.install 'scripts', 'species', 'qualimap.jar', *Dir['lib/*.jar']
    doc.install 'QualimapManual.pdf'
  end

  def test
    system 'qualimap', '-h'
  end
end
