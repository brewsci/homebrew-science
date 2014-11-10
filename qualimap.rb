require 'formula'

class Qualimap < Formula
  homepage 'http://qualimap.bioinfo.cipf.es/'
  url 'http://qualimap.bioinfo.cipf.es/release/qualimap_v2.0.zip'
  sha1 '49cc9681601631041e7f44c3e9cd232e4be50cf6'

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
