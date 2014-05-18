require 'formula'

class LumpySv < Formula
  homepage 'https://github.com/arq5x/lumpy-sv'
  url 'https://github.com/arq5x/lumpy-sv/releases/download/0.2.2.2/lumpy-sv-0.2.2.2.tar.gz'
  sha1 '87c8c686a0f554c3b34cf69597a05b1d31f9c6ee'

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
