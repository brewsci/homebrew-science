class Mcl < Formula
  homepage "http://micans.org/mcl"
  url "http://micans.org/mcl/src/mcl-14-137.tar.gz"
  version "14-137"
  sha256 "b5786897a8a8ca119eb355a5630806a4da72ea84243dba85b19a86f14757b497"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "ee751daa79605617936d8ec30f456d46d13729dbf3a43238b746683f721145c2" => :yosemite
    sha256 "e8e0fcb0da6f1177a00d4c11674824df03944c0896d1e752f513fdd94f74fa17" => :mavericks
    sha256 "0eb411a4a383fdfee14fefa90588a5d3cad38930a94866a4683bb22e219d6db6" => :mountain_lion
  end

  def install
    bin.mkpath
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-blast"
    system "make", "install"
    inreplace bin/"mcxdeblast", "/usr/local/bin/perl -w", "/usr/bin/env perl\nuse warnings;"
    inreplace bin/"clxdo", "/usr/local/bin/perl", "perl"
  end
end
