require 'formula'

class Qualimap < Formula
  homepage 'http://qualimap.bioinfo.cipf.es/'
  url 'https://bitbucket.org/kokonech/qualimap/downloads/qualimap-build-30-03-15.tar.gz'
  sha1 'ce5c8262493bda49f3eafd2568b11dfc84af7f64'
  version '30-03-15'
  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "798cc2651629a54b4adb64261fcbd156f2662bd86b6c25f0cb1494b9710fc1a1" => :yosemite
    sha256 "1916bbaaf3d8e81cb365fa38d55ca45d80e500d917f73b5da8b207286bdf7900" => :mavericks
    sha256 "203dea1e6ffaa55e9b09215e689dfd41b6118149397773cd76bdfcf7651d7ba9" => :mountain_lion
  end
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
