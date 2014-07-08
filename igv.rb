require 'formula'

class Igv < Formula
  homepage 'http://www.broadinstitute.org/software/igv'
  #doi '10.1093/bib/bbs017'
  head 'https://github.com/broadinstitute/IGV.git'
  url 'http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.34.zip'
  sha1 '1aeadbf2222f0adddd6b68b3171eb02184b7aa41'

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
