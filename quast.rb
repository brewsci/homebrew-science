require 'formula'

class Quast < Formula
  homepage 'http://bioinf.spbau.ru/en/quast'
  #doi '10.1093/bioinformatics/btt086'

  url 'https://downloads.sourceforge.net/project/quast/quast-2.3.tar.gz'
  sha1 '9bf176f852cf1b77f201b15e7d9262ae29cff727'

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
