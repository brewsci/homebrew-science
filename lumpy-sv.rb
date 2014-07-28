require 'formula'

class LumpySv < Formula
  homepage 'https://github.com/arq5x/lumpy-sv'
  url 'https://github.com/arq5x/lumpy-sv/releases/download/0.2.4/lumpy-sv-0.2.4.tar.gz'
  sha1 '5c951aac124b5dafa27de2de9ef1f3a64bef95cc'

  depends_on 'bamtools' => :recommended
  depends_on 'samtools' => :recommended
  depends_on 'bedtools' => :recommended
  depends_on 'bwa' => :optional
  depends_on 'novoalign' => :optional
  depends_on 'yaha' => :optional
  depends_on 'Statistics::Descriptive' => [:perl, :optional]
  skip_clean :all

  def install
    ENV.deparallelize
    system 'make'
    bin.install 'bin/lumpy'
    (share/'lumpy-sv').install Dir['scripts/*']
  end

  test do
    system 'lumpy 2>&1 |grep -q structural'
  end
end
