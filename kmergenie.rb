require 'formula'

class Kmergenie < Formula
  homepage 'http://kmergenie.bx.psu.edu/'
  url 'http://kmergenie.bx.psu.edu/kmergenie-1.6213.tar.gz'
  sha1 'f93622c8f2ead32cb75ba0f36b91747e969d4b6e'

  depends_on 'r'

  def install
    ENV.deparallelize
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
