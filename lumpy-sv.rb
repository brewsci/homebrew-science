require 'formula'

class LumpySv < Formula
  homepage 'https://github.com/arq5x/lumpy-sv'
  url 'https://github.com/arq5x/lumpy-sv/archive/v0.1.5.tar.gz'
  sha1 '650c4984ff80c6d60bcd4b5e86f4789e2e898fe7'

  depends_on 'gsl'
  depends_on 'bamtools'
  depends_on 'samtools' => :recommended
  depends_on 'bedtools' => :recommended
  depends_on 'bwa' => :optional
  depends_on 'novoalign' => :optional
  depends_on 'yaha' => :optional
  depends_on 'Statistics::Descriptive' => [:perl, :optional]

  def patches
    # Ensure path to GNU Scientific Library points to homebrew prefix
    DATA
  end

  def install
    system 'make'
    bin.install 'bin/lumpy'
    (share/'lumpy-sv').install Dir['scripts/*']
  end

  test do
    system 'lumpy 2>&1 |grep -q structural'
  end
end
__END__
--- a/defs.local
+++ b/defs.local
@@ -1,5 +1,4 @@
 #GSL_INCLUDE=-I/home/rl6sf/src/gsl/gsl
 #GSL_LINK=-L/home/rl6sf/src/gsl
-GSL_INCLUDE=-I/usr/local/include\
-            -I/usr/local/include/gsl
-GSL_LINK=-L/usr/local/lib
+GSL_INCLUDE=-IHOMEBREW_PREFIX/include -IHOMEBREW_PREFIX/include/gsl
+GSL_LINK=-LHOMEBREW_PREFIX/lib
