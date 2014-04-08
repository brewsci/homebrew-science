require 'formula'

class Igv < Formula
  homepage 'http://www.broadinstitute.org/software/igv'
  url 'http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.32.zip'
  sha1 '685af0ac3cd461749a0147e2b143f1d35c2df3be'

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
