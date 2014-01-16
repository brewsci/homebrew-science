require 'formula'

class Igv < Formula
  homepage 'http://www.broadinstitute.org/software/igv'
  url 'http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.25.zip'
  sha1 '2427a501144ca74889ed35da21b2f40b7184736d'

  def install
    inreplace 'igv.sh', /^prefix=.*/, 'prefix=' + libexec
    libexec.install Dir['igv.sh', '*.jar']
    bin.install_symlink '../libexec/igv.sh' => 'igv'
    doc.install 'readme.txt'
  end

  test do
    (testpath / 'script').write 'exit'
    system 'igv -b script |grep -q IGV'
  end
end
