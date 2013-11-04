require 'formula'

class Edena < Formula
  homepage 'http://www.genomic.ch/edena.php'
  url 'http://www.genomic.ch/edena/EdenaV3.131028.tar.gz'
  sha1 'aa91991776be7682707262c70b995b447eb8d607'

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
