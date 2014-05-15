require "formula"

class Hmmer2 < Formula
  homepage "http://hmmer.janelia.org/"
  #doi "10.1371/journal.pcbi.1002195"
  url "http://selab.janelia.org/software/hmmer/2.3.2/hmmer-2.3.2.tar.gz"
  sha1 "aa34cb97cbc43ff3bd92dd111ba5677298fe2d40"

  keg_only "hmmer2 conflicts with hmmer version 3"

  def install
    # Fix "make: Nothing to be done for `install'."
    rm "INSTALL"

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end

  test do
    system "#{bin}/hmmsearch", "-h"
  end
end
