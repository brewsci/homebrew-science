require 'formula'

class LumpySv < Formula
  homepage 'https://github.com/arq5x/lumpy-sv'
  url 'https://github.com/arq5x/lumpy-sv/archive/0.2.0.tar.gz'
  sha1 'a68de3b251a5a33c4ca79add27f01756bd3b91f1'

  depends_on 'bamtools' => :recommended
  depends_on 'samtools' => :recommended
  depends_on 'bedtools' => :recommended
  depends_on 'bwa' => :optional
  depends_on 'novoalign' => :optional
  depends_on 'yaha' => :optional
  depends_on 'Statistics::Descriptive' => [:perl, :optional]

  def install
    system 'make'
    bin.install 'bin/lumpy'
    (share/'lumpy-sv').install Dir['scripts/*']
  end

  test do
    system 'lumpy 2>&1 |grep -q structural'
  end
end
