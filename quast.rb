require 'formula'

class Quast < Formula
  homepage 'http://bioinf.spbau.ru/en/quast'
  url 'http://downloads.sourceforge.net/project/quast/quast-2.2.tar.gz'
  sha1 '78f4d2a6c2653d3f02dde873d20434d38322316e'

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
