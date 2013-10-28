require 'formula'

class Igv < Formula
  homepage 'http://www.broadinstitute.org/software/igv'
  url 'http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.23.zip'
  sha1 '7a0dadc578e85a3326a32f9035186d70162a042d'

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
