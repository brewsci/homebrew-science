require 'formula'

class Qualimap < Formula
  homepage 'http://qualimap.bioinfo.cipf.es/'
  url 'https://bitbucket.org/kokonech/qualimap/downloads/qualimap-build-31-08-15.tar.gz'
  sha256 "30a721b931b8e5b9304089edadbb15718bb9f2bfae70568836595196b4dd523e"
  version '20150831'
  bottle do
    cellar :any
    sha256 "312dbd9f9a0537ef4ab379d5d65d905455e7f01af827de75643d89beb0e305b0" => :yosemite
    sha256 "8ff12829b1a9ce2cf92a123dfe3e1eaa18b0c7f3929261ae93f6740878e75842" => :mavericks
    sha256 "52cffc28c7504e6c6cb3757533b2f06ea9af32f965818273f93be9a2a5f5f957" => :mountain_lion
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
