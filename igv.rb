require 'formula'

class Igv < Formula
  homepage 'http://www.broadinstitute.org/software/igv'
  url 'http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.31.zip'
  sha1 '1195d73038d0103aac90fe00a9173bf9cb60ed92'

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
