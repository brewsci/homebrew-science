require 'formula'

class Hmmer < Formula
  homepage 'http://hmmer.janelia.org/'
  url 'http://selab.janelia.org/software/hmmer3/3.1b1/hmmer-3.1b1.tar.gz'
  sha1 'e05907d28b7f03d4817bb714ff0a8b2ef0210220'

  head do
    url 'https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk'
    depends_on :autoconf
  end

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/hmmsearch", "-h"
  end
end
