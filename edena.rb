require 'formula'

class Edena < Formula
  homepage 'http://www.genomic.ch/edena.php'
  url 'http://www.genomic.ch/edena/EdenaV3.130110.tar.gz'
  sha1 '6d3033ecc7b3dd06bb26696dff2b7d6fcdcaa7e8'

  def install
    ENV.deparallelize
    system 'make'
    bin.install 'src/edena'
    doc.install 'COPYING', 'referenceManual.pdf'
  end

  def caveats
    <<-EOS.undent
      The documentation installed into
          #{HOMEBREW_PREFIX}/share/doc/#{name}
    EOS
  end

  test do
    system 'edena'
  end
end
