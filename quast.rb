require 'formula'

class Quast < Formula
  homepage 'http://bioinf.spbau.ru/en/quast'
  url 'http://downloads.sourceforge.net/project/quast/quast-2.2.tar.gz'
  sha1 '86b28a1bdb7d11626f79fdb2be68330db0cb2370'

  depends_on 'matplotlib' => :python

  def install
    libexec.install 'quast.py', 'metaquast.py', 'libs'
    bin.install_symlink '../libexec/quast.py', '../libexec/metaquast.py'
    doc.install 'manual.html'
  end

  test do
    system 'quast.py 2>&1 |grep -q quast'
  end
end
