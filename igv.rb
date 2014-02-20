require 'formula'

class Igv < Formula
  homepage 'http://www.broadinstitute.org/software/igv'
  url 'http://www.broadinstitute.org/igv/projects/downloads/IGV_2.3.8.zip'
  sha1 '55d062c17bfe422095f0a5cd5cb7adac7533db9f'

  def install
    inreplace "igv.sh", "`dirname $0`", "#{libexec}"
    libexec.install Dir['igv.sh', '*.jar']
    bin.install_symlink '../libexec/igv.sh' => 'igv'
    doc.install 'readme.txt'
  end

  test do
    (testpath / 'script').write 'exit'
    system 'igv -b script |grep -q IGV'
  end
end
