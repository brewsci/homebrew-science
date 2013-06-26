require 'formula'

class Hmmer < Formula
  homepage 'http://hmmer.janelia.org/'
  url 'http://selab.janelia.org/software/hmmer3/3.0/hmmer-3.0.tar.gz'
  sha1 '77803c0bdb3ab07b7051a4c68c0564de31940c6d'

  head 'https://svn.janelia.org/eddylab/eddys/src/hmmer/trunk'

  devel do
    url 'http://selab.janelia.org/software/hmmer3/3.1b1/hmmer-3.1b1.tar.gz'
    sha1 'e05907d28b7f03d4817bb714ff0a8b2ef0210220'
  end

  depends_on :autoconf if build.head?

  def install
    system "autoconf" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make" if build.devel? or build.head?
    system "make install"

    unless build.devel? or build.head?
      # Install man pages manually as long as automatic man page install
      # is deactivated in the HMMER 3.0 makefile.

      cd "documentation/man" do
        # rename all *.man files to *.1 and install them into man1 section
        Dir["*.man"].each do |f|
          man1.install f => f.sub(/\.man/, ".1")
        end
      end
    end
  end

  test do
    system "#{bin}/hmmsearch", "-h"
  end
end
