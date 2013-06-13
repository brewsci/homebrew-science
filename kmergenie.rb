require 'formula'

class Kmergenie < Formula
  homepage 'http://kmergenie.bx.psu.edu/'
  url 'http://kmergenie.bx.psu.edu/kmergenie-1.5351.tar.gz'
  sha1 '08591e3a644b0da10e6104f36fda80a149980268'

  depends_on 'r'

  def install
    system 'make'
    libexec.install 'kmergenie', 'specialk',
      'scripts', 'third_party'
    bin.install_symlink '../libexec/kmergenie'
    doc.install 'CHANGELOG', 'LICENSE', 'README'
  end

  test do
    system "#{bin}/kmergenie 2>&1 |grep -q kmergenie"
    system "#{libexec}/specialk"
  end
end
